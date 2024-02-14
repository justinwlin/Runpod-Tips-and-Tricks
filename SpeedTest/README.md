# Speed Testing Script
## Summary
Why run this script? It is hard to debug a networking problem cause it can either be runpod or it can be the source of the data, or something in between. But if you run this script, it can help give a contrasting dataset to what you are experiencing with something else and let you know if it is just the source of the data or if it is the runpod (by allowing runpod to test against other data sources).

If the speed is really slow on one of the sources you can use flags to skip that source and test the other sources. I do recommend at minimum test the speed-test-cli and a couple of the other download file sources.

The test actually **will max out downloads at 5 minutes for every request and still capture information** so there is no need to skip it if you just wait for 5 minutes, but it is just an option. You don't need to worry about if you need to sit there for an hour waiting for it to finish. Every test will take a max of 5 mins, and as said before you can specify a the tests to run such as the speed test cli and a couple other sources if u don't want to test across the board.

## Options
No flag provided will auto run the whole script
```
Usage: test.sh [options]

Options:
  -h, --help                Show this help message and exit.
  -p, --package-update      Update package lists and install required packages.
  -s, --speedtest           Perform speed tests with specified server IDs.
  -c, --civitai             Download from Civitai and log the speed.
  -f, --huggingface         Download from Hugging Face and log the speed.
  -3, --s3                  Perform S3 parallel download test and log the speed.
  -b, --broadband-test      Test download speed using a broadband test file.
  -a, --all                 Run the entire script (default if no option is provided).

Example:
  speed.sh -p -s -c -f -b         Update packages, perform speed tests, download from Civitai, Hugging Face, and test broadband download speed.
  speed.sh --all                  Run the entire script.
```

## What the script will do
Run speed tests + run a variety of models + dump your ID of your Runpod so that it is easier to check if something is wrong with your pod or wrong with your downstream source.

## Testing Methodology
1. Runs a speed test against speedtest-cli
2. Downloads a model from civitai ~ 2GB
3. Downloads a model from hugging face ~ 4.2GB
3. Downloads 5GB from a 200GB model on S3 Bucket using parallel curl requests
5. Download a 1GB file from broadband

## Potential Future Issues
Civitai authors ocassionally require an auth token to download a model, but I tried to find one that doesn't have that issue.

S3 Bucket Link is a link I used in the past for an ML dataset, hopefully the author doesn't take it down.

HuggingFace can sometimes have issues, but this link I imagine should stay stable. Is always worth sanity checking if my script throws out weird errors like unable to download if the urls have become invalid.

Broadband should hopefully stay stable

## How to Run
Copy and paste the script as a .sh script onto your machine.

Run it in the terminal using:
```
bash nameOfYourscript.sh
```

For example, I might run it as:
```
bash speed_test.sh
```

## Example Results for Comparison

### Example 1
Example Speed Test Results:
This is on a CPU POD:
```
RO
797 Mbps Download
894 Mbps Upload
```
```
RUNPOD_POD_ID: afkvx3yxjqiniy
RUNPOD_PUBLIC_IP: 213.173.105.83
RUNPOD_DC_ID: EU-RO-1
-------------------------------------------------
Server ID, Server Name, Download, Upload
-------------------------------------------------
Testing server ID: 20386
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by WaveCom (Turkeve) [347.87 km]: 31.337 ms
Testing download speed................................................................................
Download: 749.77 Mbit/s
Testing upload speed......................................................................................................
Upload: 617.64 Mbit/s
-------------------------------------------------
Downloading file from: https://civitai.com/api/download/models/272376?type=Model&format=SafeTensor&size=pruned&fp=fp16
Download Speed: 34678825 bytes/sec
Downloaded Size: 2132650982 bytes
-------------------------------------------------
Downloading file from: https://huggingface.co/TheBloke/falcon-7b-instruct-GGML/resolve/main/falcon-7b-instruct.ggccv1.q4_1.bin --output falcon-7b-instruct.ggccv1.q4_1.bin
Download Speed: 171805977 bytes/sec
Downloaded Size: 4513676672 bytes
-------------------------------------------------
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 2)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 1)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 3)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 4)

 Download Speed: 23440341 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------

Download Speed: 23058495 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------

 Download Speed: 19017071 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------

 Download Speed: 11811998 bytes/sec
Downloaded Size: 1250000001 bytes
-------------------------------------------------
```

### Example 2
This is a CPU Pod:
```
797 Download
894 Upload
```

```
RUNPOD_POD_ID: 7s1w09qsovkgds
RUNPOD_PUBLIC_IP: 213.173.105.83
RUNPOD_DC_ID: EU-RO-1
-------------------------------------------------
Server ID, Server Name, Download, Upload
-------------------------------------------------
Testing server ID: 47074
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by ISP INFO-CENTR (Tyachiv) [249.26 km]: 1800000.0 ms
Testing download speed................................................................................
Download: 0.00 Mbit/s
Testing upload speed......................................................................................................
Upload: 0.00 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 24567
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Djemba IT&C (Arad) [284.90 km]: 18.097 ms
Testing download speed................................................................................
Download: 726.12 Mbit/s
Testing upload speed......................................................................................................
Upload: 573.29 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 49368
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Cnetwork (Curtici) [286.70 km]: 23.405 ms
Testing download speed................................................................................
Download: 658.50 Mbit/s
Testing upload speed......................................................................................................
Upload: 438.71 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 55778
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by DVS-Sat LLC (Mukachevo) [322.69 km]: 46.699 ms
Testing download speed................................................................................
Download: 652.42 Mbit/s
Testing upload speed......................................................................................................
Upload: 408.58 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 23082
Retrieving speedtest.net configuration...
Testing from EVOBITS Information Technology SRL (213.173.105.83)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Naracom Kft. (Kisvárda) [330.95 km]: 21.829 ms
Testing download speed................................................................................
Download: 1903.08 Mbit/s
Testing upload speed......................................................................................................
Upload: 904.52 Mbit/s
-------------------------------------------------
Downloading file from: https://civitai.com/api/download/models/272376?type=Model&format=SafeTensor&size=pruned&fp=fp16
Download Speed: 42203354 bytes/sec
Downloaded Size: 2132650982 bytes
-------------------------------------------------
Downloading file from: https://huggingface.co/TheBloke/falcon-7b-instruct-GGML/resolve/main/falcon-7b-instruct.ggccv1.q4_1.bin --output falcon-7b-instruct.ggccv1.q4_1.bin
Download Speed: 121905686 bytes/sec
Downloaded Size: 4513676672 bytes
-------------------------------------------------
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 2)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 1)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 4)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 3)

 Download Speed: 22156194 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------

 Download Speed: 19921939 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------

 Download Speed: 18935497 bytes/sec
Downloaded Size: 1250000001 bytes
-------------------------------------------------

 Download Speed: 15793836 bytes/sec
Downloaded Size: 1250000000 bytes
-------------------------------------------------
```
