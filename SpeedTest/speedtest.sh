#!/bin/bash

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
    
    # Use curl to download the file and directly append the speed and size to the results file
    echo "Downloading file from: $url" >> "$results_file"
    curl -o /dev/null -L $url -w "Download Speed: %{speed_download} bytes/sec\nDownloaded Size: %{size_download} bytes\n" >> "$results_file"
    echo "-------------------------------------------------" >> "$results_file"
}

# Call the function to write environment variables
write_env_to_file

# # Prepare results file
echo "Server ID, Server Name, Download, Upload" >> "$results_file"

# Define server IDs and download URL
server_ids=$(speedtest-cli --list | grep -o '^[ ]*[0-9]*' | head -n 5)

download_url="https://civitai.com/api/download/models/272376?type=Model&format=SafeTensor&size=pruned&fp=fp16"
download_url_huggingface="https://huggingface.co/TheBloke/falcon-7b-instruct-GGML/resolve/main/falcon-7b-instruct.ggccv1.q4_1.bin --output falcon-7b-instruct.ggccv1.q4_1.bin"


# Check if server_ids is empty
if [ -z "$server_ids" ]; then
    echo "No server IDs could be retrieved."
    exit 1
fi
# Perform speed tests
for id in $server_ids; do
    perform_speedtest_and_log $id $results_file
done

# Download file and check speed
download_file_and_log_speed "$download_url" "$results_file"
download_file_and_log_speed "$download_url_huggingface" "$results_file"

# Parallel download test
# Define download URL and byte ranges for parallel connections
# The bucket has 200GB worth of data, so let's just download the first 5GB worth and test parallel downloads
perform_parallel_download_test() {
    local url=$1
    local start_range=$2
    local end_range=$3
    local results_file=$4
    local thread_number=$5
    
    # Use curl to download the file and directly append the speed and size to the results file
    echo "Testing download speed from: $url (Thread Number: $thread_number)" >> "$results_file"
    curl -o /dev/null --max-filesize 5000000000 -L $url -r $start_range-$end_range -w "\n Download Speed: %{speed_download} bytes/sec\nDownloaded Size: %{size_download} bytes\n" >> "$results_file"
    echo "-------------------------------------------------" >> "$results_file"
}
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
# Wait for all background jobs to finish
wait
# Display results
echo "Speedtest results summary:"
cat "$results_file"
