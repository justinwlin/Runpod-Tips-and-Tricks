# Speed Testing Script
## Summary
Why run this script? It is hard to debug a networking problem cause it can either be runpod or it can be the source of the data, or something in between. But if you run this script, it can help give a contrasting dataset to what you are experiencing with something else and let you know if it is just the source of the data or if it is the runpod (by allowing runpod to test against other data sources).

## What the script will do
Run speed tests + run a variety of models + dump your ID of your Runpod so that it is easier to check if something is wrong with your pod or wrong with your downstream source.

## Testing Methodology
1. Runs a speed test against speedtest-cli
2. Downloads a model from civitai ~ 2GB
3. Downloads a model from hugging face ~ 4.2GB
3. Downloads 5GB from a 200GB model on S3 Bucket using parallel curl requests

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