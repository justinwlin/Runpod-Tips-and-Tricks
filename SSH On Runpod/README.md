# Summary
This is a guide to help you either: set up ssh on your pod (either to connect vscode or whatever you want to do), or on how to transfer files between you and your computer, or pod to pod.

# Croc / Runpodctl Relay Servers

Runpodctl has an easy way to send files; the issue is they use custom relay servers meaning that it can get bottlenecked so heavily where your transfer rate drops below 1Mbps. 


https://github.com/runpod/runpodctl

If you just use the underlying library they have directly, you can send files from your computer and between pods easily at a fast rate. And the setup is minimal. 

The library they use is crocs.
https://github.com/schollz/croc
```
curl https://getcroc.schollz.com | bash
```

```
$ croc send [file(s)-or-folder]
Sending 'file-or-folder' (X MB)
Code is: code-phrase
```

So why consider a different alternative? If you use SSH/SCP which I talk about below for file transfers you have a direct transfer connection computer to computer vs moving data in between another computer. 

However croc / runpodctl does allow way easier setup + also if one of the computers may not allow ssh / tcp.

# SSH On Runpod

## Overview
First what is SSH? SSH is (secure shell protocol) is a network protocol that allows data to be exchanged using a secure channel between two networked devices. What it allows you to do is connect through terminal to a remote machine and execute commands. 

SCP is built ontop of SSH, which uses the same protocol to transfer files.

You also have SFTP which is a separate protocol that is more flexible for other operations like file browsing and file management. But for pure file transfer, SCP will have less overhead. 

There is also other methods like using `runpodctl` / `croc` to transfer files, which uses a relay server to transfer files, making authorizations and stuff less painful, but has it's own things to consider like having a middle man server, but I will discuss all of it below.

## Why use SSH?

SSH let's you have a DIRECT computer to computer connection to the pod. Or from one pod to another. What this means is that, you can have the most pure connection to the pod, that is only limited by either your bandwidth or the pod.

## How to know if your Pod can use SSH?

> TLDR: If you are using a Runpod Official template it probably has SSH on it, and if you have access to a web terminal you can most likely also SSH too.

To SSH onto Runpod, you need to make sure that your docker container has OpenSSH installed and launched. If you have a Runpod official template running then this OpenSSH should already be installed (essentially you can tell if you can web terminal usually on it).

If you are using a custom container, you can install OpenSSH. You can see how in all of Runpod's template they start up [ssh here](https://github.com/runpod/containers/blob/main/container-template/start.sh). But that is not what this is trying to cover. 

# Setting up SSH

## Why do this?
- SCP
- Connect to [VSCode](https://blog.runpod.io/how-to-connect-vscode-to-runpod/)
  - Going through this solves the first part of the article asking you to create public/private key pairing.

## Option 1: Using Runpod's Pip Package for SSH using Public / Private Keys
> This only works for **FUTURE PODS** that you create, not any existing pods. If you have an existing pod you must SSH onto, use Option 2.

### Step 1: Install the Runpod Python Package
Install the runpod package using pip:
```
pip install runpod
```

Verify the installation by checking the available commands:
runpod --help

You can see the help command output [here.](https://github.com/runpod/runpod-python/blob/main/docs/cli/demos/help.gif)

Step 2: Configure Runpod (One-time Setup)

```
runpod config
```

This is a one-time setup requirement.

Step 3: Add an SSH Key
```
runpod ssh add-key
```

Step 4: Connecting to Your Pod

To connect to your pod in the future, simply use:

```
runpod pod connect [YOUR_POD_ID_HERE]
```

Or use the command that the Runpod **connect** button tells you and you can run that in your terminal too. If you are setting up [VSCode](https://blog.runpod.io/how-to-connect-vscode-to-runpod/) you have now essentially done the first point in the article, asking you to set up public / private keys.

# Transfering Files using SSH

If confused ask ChatGPT / [Phind](https://www.phind.com/search?home=true)

Under the connect tab for Runpod you can find an example command to SSH to it:
```
ssh root@213.173.105.83 -p 11817 -i ~/.ssh/id_ed25519
```

You can use this command as a basis to SCP:

Sending a file to Pod:
```
scp -P 11817 /path/to/your/local/file.txt root@213.173.105.83:/path/where/you/want/to/put/file
```

Downloading a file from Pod:
```
scp -P 11817 root@/path/to/your/remote/file.txt /path/where/you/want/to/put/file_locally
```

## WARNING
When you SSH into runpod, even though it looks like you are at the root of it, you are actually in a `/root` folder usually, that looks like `/`. 

You can actually `cd ..` and go to the actual root. Any time you are confused where a file is, `ls` to see all the current files there, `pwd` to see the current directory, and `cd` to change directory.

Also if you want to copy over a **directory** zip and compress the directory before SCP it over. Transfering a bunch of tiny files is slow and inefficient vs one big file.

# Using an SSH Wrapper:
I added a CLI command (https://github.com/runpod/runpod-python/pull/266) so that you can send and download files from runpod without having to manually writing out the SCP command:

```
pip uninstall runpod
pip install git+https://github.com/justinwlin/runpod-python

# Sending a file
runpod pod send <PODID> localtext.txt /remote.txt

# Downloading a file
runpod pod download <PODID> remote.txt local.txt
```

# Option 2: Using Password SSH (must setup every time on a new pod)
Madiator a Runpod staff, has created a good repo called OhMyRunPod which let's you do some simple stuff like instead of SSH with files, you can just use a password:

https://discord.com/channels/912829806415085598/1202555381126008852

On the pods you can:
```
pip install OhMyRunPod
OhMyRunPod --setup-ssh
cat /workspace/root_password.txt
```

# Transfering Files between two pods

With Madiator's setup in Option 2, you can setup a password on both pods.

Then you can just use the `scp` or `ssh` command to connect to the other pod, assuming both pods have passwords setup. It will ask you. 

For example:
```
scp -P 11817 /path/to/your/local/file.txt root@213.173.105.83:/path/where/you/want/to/put/file
```

