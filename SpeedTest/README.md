# Speed Testing Script
## Summary
Why run this script? It is hard to debug a networking problem cause it can either be runpod or it can be the source of the data, or something in between. But if you run this script, it can help give a contrasting dataset to what you are experiencing with something else and let you know if it is just the source of the data or if it is the runpod (by allowing runpod to test against other data sources).

If the speed is really slow on one of the sources you can use flags to skip that source and test the other sources. I do recommend at minimum test the speed-test-cli and a couple of the other download file sources.

The test actually **will max out downloads at 5 minutes for every request and still capture information** so there is no need to skip it if you just wait for 5 minutes, but it is just an option. You don't need to worry about if you need to sit there for an hour waiting for it to finish. Every test will take a max of 5 mins, and as said before you can specify a the tests to run such as the speed test cli and a couple other sources if u don't want to test across the board.

## Quick Start
```
curl -s https://raw.githubusercontent.com/justinwlin/Runpod-Tips-and-Tricks/main/SpeedTest/speedtest.sh -o speedtest.sh && chmod +x speedtest.sh && ./speedtest.sh
```

## Options
No flag provided will auto run the whole script
```
show_help() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help                Show this help message and exit."
    echo "  -p, --package-update      Update package lists and install required packages."
    echo "  -s, --speedtest-cli       Perform speed tests with specified server IDs using speedtest-cli which tests against speedtest.net"
    echo "  -c, --civitai             Download from Civitai and log the speed."
    echo "  -f, --huggingface         Download from Hugging Face and log the speed."
    echo "  -3, --s3                  Perform S3 parallel download test and log the speed."
    echo "  -b, --broadband-test      Test download speed using a broadband test file."
    echo "  -a, --all                 Run the entire script (default if no option is provided)."
    echo ""
    echo "Example:"
    echo "  $0 -p -c -f -b         Update packages, download from Civitai, Hugging Face, and test broadband download speed."
    echo "  $0 --all                  Run the entire script."
}
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
This is on GPU POD Secure Cloud:
```
SE
7583 Mbps Download
1384 Mbps Upload
```
```
RUNPOD_POD_ID: 4zuaevqn5czw6j
RUNPOD_PUBLIC_IP: 194.68.245.21
RUNPOD_DC_ID: EU-SE-1
-------------------------------------------------
Server ID, Server Name, Download, Upload
-------------------------------------------------
Testing server ID: 20783
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by A3 Allmänna IT - och Telekomaktiebolaget (Stockholm) [0.89 km]: 4.009 ms
Testing download speed................................................................................
Download: 523.04 Mbit/s
Testing upload speed......................................................................................................
Upload: 516.35 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 34441
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Telenor AB (Stockholm) [0.89 km]: 4.102 ms
Testing download speed................................................................................
Download: 423.43 Mbit/s
Testing upload speed......................................................................................................
Upload: 397.01 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 30885
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Vakka-Suomen Puhelin (Uusikaupunki) [248.28 km]: 13.11 ms
Testing download speed................................................................................
Download: 371.45 Mbit/s
Testing upload speed......................................................................................................
Upload: 168.24 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 31700
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Internetport Sweden AB (Hudiksvall) [272.15 km]: 9.271 ms
Testing download speed................................................................................
Download: 584.25 Mbit/s
Testing upload speed......................................................................................................
Upload: 519.71 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 59529
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Ansluten Hosting i Sverige AB (Växjö) [332.22 km]: 14.022 ms
Testing download speed................................................................................
Download: 533.16 Mbit/s
Testing upload speed......................................................................................................
Upload: 136.93 Mbit/s
-------------------------------------------------
-------------------------------------------------
Testing server ID: 5654
Retrieving speedtest.net configuration...
Testing from Unknown (194.68.245.21)...
Retrieving speedtest.net server list...
Retrieving information for the selected server...
Hosted by Telset AS (Tallinn) [379.44 km]: 12.028 ms
Testing download speed................................................................................
Download: 337.78 Mbit/s
Testing upload speed......................................................................................................
Upload: 184.90 Mbit/s
-------------------------------------------------
Pinging civitai.com...
PING civitai.com (104.18.22.206) 56(84) bytes of data.
64 bytes from 104.18.22.206 (104.18.22.206): icmp_seq=1 ttl=59 time=1.45 ms
64 bytes from 104.18.22.206 (104.18.22.206): icmp_seq=2 ttl=59 time=1.01 ms
64 bytes from 104.18.22.206 (104.18.22.206): icmp_seq=3 ttl=59 time=1.40 ms
64 bytes from 104.18.22.206 (104.18.22.206): icmp_seq=4 ttl=59 time=0.927 ms
64 bytes from 104.18.22.206 (104.18.22.206): icmp_seq=5 ttl=59 time=1.34 ms

--- civitai.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 0.927/1.223/1.446/0.214 ms
Tracerouting civitai.com...
traceroute to civitai.com (104.18.23.206), 30 hops max, 60 byte packets
 1  192.168.212.1 (192.168.212.1)  0.071 ms  0.020 ms  0.018 ms
 2  * * *
 3  11755200150.ip.84grams.net (117.55.200.150)  1.874 ms  1.839 ms  1.809 ms
 4  sth-r16.84gra.ms (31.12.81.138)  0.982 ms  0.952 ms  0.913 ms
 5  netnod-ix-ge-b-sth-1500.cloudflare.com (194.68.128.246)  4.279 ms  4.251 ms *
 6  104.18.23.206 (104.18.23.206)  1.335 ms  1.442 ms  1.341 ms
Downloading file from: https://civitai.com/api/download/models/272376?type=Model&format=SafeTensor&size=pruned&fp=fp16
Download Speed: 37896303 bytes/sec
Downloaded Size: 2132650982 bytes
Elapsed Time: 56.275963 seconds
-------------------------------------------------
Pinging huggingface.co...
PING huggingface.co (52.85.242.16) 56(84) bytes of data.
64 bytes from server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16): icmp_seq=1 ttl=247 time=0.859 ms
64 bytes from server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16): icmp_seq=2 ttl=247 time=0.894 ms
64 bytes from server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16): icmp_seq=3 ttl=247 time=0.819 ms
64 bytes from server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16): icmp_seq=4 ttl=247 time=0.950 ms
64 bytes from server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16): icmp_seq=5 ttl=247 time=0.867 ms

--- huggingface.co ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 0.819/0.877/0.950/0.043 ms
Tracerouting huggingface.co...
traceroute to huggingface.co (52.85.242.16), 30 hops max, 60 byte packets
 1  192.168.212.1 (192.168.212.1)  0.060 ms  0.016 ms  0.014 ms
 2  * * *
 3  11755200150.ip.84grams.net (117.55.200.150)  0.739 ms  1.982 ms  1.958 ms
 4  bma-r23.84gra.ms (31.12.80.128)  1.184 ms  1.152 ms  1.127 ms
 5  151.148.14.78 (151.148.14.78)  1.092 ms  1.061 ms  1.038 ms
 6  52.93.144.72 (52.93.144.72)  1.472 ms 52.93.144.120 (52.93.144.120)  1.145 ms 52.93.144.72 (52.93.144.72)  1.603 ms
 7  52.93.144.45 (52.93.144.45)  6.270 ms 52.93.144.145 (52.93.144.145)  1.284 ms  1.252 ms
 8  52.93.129.214 (52.93.129.214)  4.053 ms 52.93.129.220 (52.93.129.220)  1.528 ms 52.93.129.214 (52.93.129.214)  3.987 ms
 9  52.93.143.34 (52.93.143.34)  1.226 ms 52.93.143.112 (52.93.143.112)  1.557 ms 52.93.143.124 (52.93.143.124)  1.627 ms
10  150.222.203.43 (150.222.203.43)  1.221 ms 150.222.203.33 (150.222.203.33)  1.097 ms 150.222.203.39 (150.222.203.39)  1.777 ms
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  server-52-85-242-16.arn1.r.cloudfront.net (52.85.242.16)  0.860 ms  0.911 ms  0.841 ms
Downloading file from: https://huggingface.co/TheBloke/falcon-7b-instruct-GGML/resolve/main/falcon-7b-instruct.ggccv1.q4_1.bin
Download Speed: 203977137 bytes/sec
Downloaded Size: 4513676672 bytes
Elapsed Time: 22.128346 seconds
-------------------------------------------------
Pinging ipv4.download.thinkbroadband.com...
PING ipv4.download1.thinkbroadband.com (80.249.99.148) 56(84) bytes of data.
64 bytes from download.thinkbroadband.com (80.249.99.148): icmp_seq=1 ttl=54 time=29.7 ms
64 bytes from download.thinkbroadband.com (80.249.99.148): icmp_seq=2 ttl=54 time=29.6 ms
64 bytes from download.thinkbroadband.com (80.249.99.148): icmp_seq=3 ttl=54 time=29.6 ms
64 bytes from download.thinkbroadband.com (80.249.99.148): icmp_seq=4 ttl=54 time=29.7 ms
64 bytes from download.thinkbroadband.com (80.249.99.148): icmp_seq=5 ttl=54 time=29.5 ms

--- ipv4.download1.thinkbroadband.com ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 29.540/29.627/29.687/0.057 ms
Tracerouting ipv4.download.thinkbroadband.com...
traceroute to ipv4.download.thinkbroadband.com (80.249.99.148), 30 hops max, 60 byte packets
 1  192.168.212.1 (192.168.212.1)  0.060 ms  0.016 ms  0.016 ms
 2  10.1.7.254 (10.1.7.254)  0.236 ms  0.184 ms  0.163 ms
 3  11755200150.ip.84grams.net (117.55.200.150)  1.368 ms  1.336 ms  1.309 ms
 4  bma-r23.84gra.ms (31.12.80.128)  1.149 ms  1.122 ms  1.063 ms
 5  ce-0-0-0-2.r01.stocse01.se.bb.gin.ntt.net (83.231.187.145)  1.064 ms  1.038 ms  1.066 ms
 6  ae-7.r20.amstnl07.nl.bb.gin.ntt.net (129.250.3.68)  24.905 ms  24.849 ms  24.781 ms
 7  ae-15.r20.londen12.uk.bb.gin.ntt.net (129.250.5.1)  30.413 ms  29.753 ms  29.727 ms
 8  ae-13.a03.londen12.uk.bb.gin.ntt.net (129.250.3.249)  29.693 ms  29.664 ms  36.226 ms
 9  192.80.16.146 (192.80.16.146)  29.783 ms  29.759 ms  29.733 ms
10  ae11-11.edge-rt1.thn.ncuk.net (80.249.97.20)  29.831 ms  29.806 ms  29.779 ms
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  * * *
22  * * *
23  * * *
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *
Downloading file from: http://ipv4.download.thinkbroadband.com/1GB.zip
Download Speed: 98833331 bytes/sec
Downloaded Size: 1073741824 bytes
Elapsed Time: 10.864167 seconds
-------------------------------------------------
Pinging ...
Tracerouting ...
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 1)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 2)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 3)
Testing download speed from: https://netspresso-research-code-release.s3.us-east-2.amazonaws.com/data/improved_aesthetics_6.25plus/preprocessed_2256k.tar.gz (Thread Number: 4)

 Download Speed: 27493662 bytes/sec
Downloaded Size: 1250000000 bytes
Elapsed Time: 45.465023 seconds
-------------------------------------------------

 Download Speed: 24041904 bytes/sec
Downloaded Size: 1250000001 bytes
Elapsed Time: 51.992554 seconds
-------------------------------------------------

 Download Speed: 23893999 bytes/sec
Downloaded Size: 1250000000 bytes
Elapsed Time: 52.314389 seconds
-------------------------------------------------

 Download Speed: 20802884 bytes/sec
Downloaded Size: 1250000000 bytes
Elapsed Time: 60.087821 seconds
-------------------------------------------------
```