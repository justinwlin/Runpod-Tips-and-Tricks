#!/bin/bash

# Function to show help message
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message and exit."
    echo "  -p, --package-update      Update package lists and install required packages."
    echo "  -s, --speedtest           Perform speed tests with specified server IDs."
    echo "  -c, --civitai             Download from Civitai and log the speed."
    echo "  -f, --huggingface         Download from Hugging Face and log the speed."
    echo "  -3, --s3                  Perform S3 parallel download test and log the speed."
    echo "  -b, --broadband-test      Test download speed using a broadband test file."
    echo "  -a, --all                 Run the entire script (default if no option is provided)."
    echo ""
    echo "Example:"
    echo "  $0 -p -s -c -f -b         Update packages, perform speed tests, download from Civitai, Hugging Face, and test broadband download speed."
    echo "  $0 --all                  Run the entire script."
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -p|--package-update)
            package_update_flag=true
            shift
            ;;
        -s|--speedtest)
            speedtest_flag=true
            shift
            ;;
        -c|--civitai)
            civitai_download_flag=true
            shift
            ;;
        -f|--huggingface)
            huggingface_download_flag=true
            shift
            ;;
        -3|--s3)
            s3_download_flag=true
            shift
            ;;
        -a|--all)
            all_flag=true
            shift
            ;;
        -b|--broadband-test)
            broadband_test_flag=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# If no flags are provided, run the entire script
if [ -z "$package_update_flag" ] && [ -z "$speedtest_flag" ] && [ -z "$civitai_download_flag" ] && [ -z "$huggingface_download_flag" ] && [ -z "$s3_download_flag" ] && [ -z "$all_flag" ]; then
    all_flag=true
fi

# Install relevant packages
# Install relevant packages
if [ "$package_update_flag" == true ] || [ "$all_flag" == true ]; then
    echo "Updating package lists..."
    apt-get update
    # Check if speedtest-cli is installed and install if not
    if ! command -v speedtest-cli &> /dev/null; then
        echo "Installing speedtest-cli..."
        # Before installing speedtest-cli, check for and handle the existing speedtest package
        if dpkg -l | grep -qw speedtest; then
            echo "Trying to remove existing 'speedtest' package to avoid conflicts..."
            apt-get remove -y speedtest
        fi
        apt-get install -y speedtest-cli
    else
        echo "speedtest-cli is already installed."
    fi
    # Auto-yes the installation of curl
    echo "Installing curl..."
    apt-get install -y curl
fi


# Define results file
results_file="speedtest_results_summary.txt"

write_env_to_file() {
    echo "RUNPOD_POD_ID: ${RUNPOD_POD_ID:-'does not exist'}" > "$results_file"
    echo "RUNPOD_PUBLIC_IP: ${RUNPOD_PUBLIC_IP:-'does not exist'}" >> "$results_file"
    echo "RUNPOD_DC_ID: ${RUNPOD_DC_ID:-'does not exist'}" >> "$results_file"
    echo "-------------------------------------------------" >> "$results_file"
}

# Function to perform speed test and parse results
perform_speedtest_and_log() {
    local server_id=$1
    local results_file=$2

    # Run speedtest-cli and append the output directly to the results file
    echo "-------------------------------------------------" >> "$results_file"
    echo "Testing server ID: $server_id" >> "$results_file"
    speedtest-cli --server $server_id >> "$results_file"
    echo "-------------------------------------------------" >> "$results_file"
}

# Function to download a file and measure speed
download_file_and_log_speed() {
    local url=$1
    local results_file=$2
    local max_time=300 # Maximum time in seconds for the download
    
    # Log the download initiation
    echo "Downloading file from: $url" >> "$results_file"
    
    # Use curl to download the file with a timeout, and log the average speed and size
    curl -o /dev/null -L $url --max-time $max_time \
    -w "Download Speed: %{speed_download} bytes/sec\nDownloaded Size: %{size_download} bytes\nElapsed Time: %{time_total} seconds\n" >> "$results_file"
    
    # Check if the download was capped by --max-time
    if [ $? -eq 28 ]; then
        echo "Download was terminated after $max_time seconds due to timeout." >> "$results_file"
    fi
    
    # Log a separator for readability
    echo "-------------------------------------------------" >> "$results_file"
}

broadband_test_download() {
    local download_url="http://ipv4.download.thinkbroadband.com/1GB.zip"
    download_file_and_log_speed $download_url $results_file
}

perform_parallel_download_test() {
    local url=$1
    local start_range=$2
    local end_range=$3
    local results_file=$4
    local thread_number=$5
    local max_time=300 # Set the maximum time for the download in seconds

    # Use curl to download the file and directly append the speed and size to the results file
    echo "Testing download speed from: $url (Thread Number: $thread_number)" >> "$results_file"
    curl -o /dev/null --max-time $max_time --max-filesize 5000000000 -L $url -r $start_range-$end_range \
    -w "\n Download Speed: %{speed_download} bytes/sec\nDownloaded Size: %{size_download} bytes\nElapsed Time: %{time_total} seconds\n" >> "$results_file"
    
    # Check if the download was terminated due to timeout
    if [ $? -eq 28 ]; then
        echo "Download was terminated after $max_time seconds due to timeout (Thread Number: $thread_number)." >> "$results_file"
    fi

    echo "-------------------------------------------------" >> "$results_file"
}


# Conditional execution based on flags for civitai, huggingface, and s3 downloads
write_env_to_file

# Speed Test
if [ "$speedtest_flag" == true ] || [ "$all_flag" == true ]; then
    # Prepare results file
    echo "Server ID, Server Name, Download, Upload" >> "$results_file"
    # Define server IDs
    server_ids=$(speedtest-cli --list | grep -o '^[ ]*[0-9]*' | head -n 5)
    # Call function to perform speed test and parse results
    for server_id in $server_ids; do
        perform_speedtest_and_log $server_id $results_file
    done
fi

# Civitai download
if [ "$civitai_download_flag" == true ] || [ "$all_flag" == true ]; then
    # Call download function for Civitai
    download_url="https://civitai.com/api/download/models/272376?type=Model&format=SafeTensor&size=pruned&fp=fp16"
    download_file_and_log_speed $download_url $results_file
fi

# Hugging Face download
if [ "$huggingface_download_flag" == true ] || [ "$all_flag" == true ]; then
    download_url_huggingface="https://huggingface.co/TheBloke/falcon-7b-instruct-GGML/resolve/main/falcon-7b-instruct.ggccv1.q4_1.bin"
    # Call download function for Hugging Face
    download_file_and_log_speed $download_url_huggingface $results_file
fi

# Broadband file download
if [ "$broadband_test_flag" == true ] || [ "$all_flag" == true ]; then
    broadband_test_download
fi

# S3 parallel download test
if [ "$s3_download_flag" == true ] || [ "$all_flag" == true ]; then
    # Call function for S3 parallel download test
    # Define download URL and byte ranges for parallel connections
    download_url="https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz"
    declare -a byte_ranges=("0-1250000000" "1250000001-2500000000" "2500000001-3750000000" "3750000001-5000000000")
    # Perform parallel download test
    thread_number=1
    for range in "${byte_ranges[@]}"; do
        IFS='-' read -ra ADDR <<< "$range"
        perform_parallel_download_test "$download_url" "${ADDR[0]}" "${ADDR[1]}" "$results_file" "$thread_number" &
        thread_number=$((thread_number+1))
    done
fi

# Wait for all background jobs to finish
wait
# Display results
echo "Speedtest results summary:"
cat "$results_file"
