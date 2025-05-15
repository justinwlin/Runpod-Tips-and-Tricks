# Overview

Runpod has two primary features: "pod" and "serverless".

The biggest thing to realize though is they are "practically" the same underneath - what do I mean?

# Pods
Pods are you are renting a machine with a GPU from Runpod. So you can run whatever workload you want on it.

# Serverless

Serverless is that you are still renting a machine with a GPU from Runpod, the only difference is instead of you "manually starting it up", you send to an endpoint that Runpod has, a "request", which gets put into a managed queue, which then when the "machine is spun up" (aka the pod), it will pull from that managed queue, and execute your job.

# Thus...
I actually have an example repository where you can debug with a handler.py on a Pod first, and then switch over to serverless using an ENV variable that you set, and it will work the same between a Pod vs a serverless. This makes debugging much easier!

https://github.com/justinwlin/Runpod-GPU-And-Serverless-Base