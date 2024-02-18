# Storage on Runpod [WIP]

Storage is a common question on Runpod. This document will help you understand how storage works on runpod and the different options.

## Topics That Will be Covered
- Container vs Volume Storage on GPU Pod
- Network Storage on GPU Pod
- Using Third Party Providers for Storage
- Tools to Sync Data to Runpod
- Network Storage for Serverless

# Container vs Volume Storage on a GPU Pod

When you create a pod on Runpod, if you have no network storage attached, it will ask you to allocate storage between container and volume storage. To understand why this is important, first you need to understand that a pod with no network storage can exist in 3 states:

1. **Active** - Meaning the pod is active and being used
2. **Stopped** - Meaning the GPU has been released and the pod is not active. When you start the pod again, it will try to get a GPU with the same specs, but it might not be able to, meaning, you might need to launch the pod with no GPU to recover your data. When stopped you are **paying** for idle storage, which will be talked about further.
3. **Terminated** - Meaning you trashed the pod and no longer being charged for it. 

Okay so now back to what is container vs volume. When you launch a pod, it will ask you where you want the volume to be, usually this is under `/workspace`. This is where the volume storage is and where when you stop the pod, anything in this folder will stay the same. However, the `container` storage is anything outside of this /workspace folder. Meaning pip installations, model installations, etc. potentially if none of this is under /workspace, when you stop and start the pod again, you will find this reset to the initial state of whatever the Docker image  has it defined as. So thus: container storage is `ephemeral` while `volume` is persistent. 

# Network Storage on GPU Pod

So what is network storage then? Well network storage is you can think of it as an `external harddrive` that pods can plug into. So just like before in the section above, it will usually mount to `/workspace` unless you define otherwise. And any pods can plug into this network storage. For example, if you launch two pods and both of them are attached to the same network storage you will see that they are sharing space with each other. 

But what are the draw-backs? A network storage can **only** exist in a **single region**. Meaning that you should try to put the network storage in a region that have high avaliability / medium avaliability for your GPU that you use in. 

If you want to transfer data between two pods in different regions can read my `SSH On Runpod` in this repository.

What does a network storage mean for a Pod's life cycle then? It means that it will only have two states:
1. **Active** - Meaning the pod is active and being used
3. **Terminated** - Meaning you trashed the pod and no longer being charged for it. 

There is no longer any need for a `stopped` state, as the data is not stored on the pod, but on the network storage. This also means, you do not risk, when you start up the Pod, not having any GPUs avaliable and can just instead terminate the pod, and launch a GPU of a different spec onto the network storage.

## Important Notes to know about Network Storage

### It can be slow

### Bad with many small files


# Using Third Party Providers for Storage

There are many third party providers that you can use for storage. Why should you consider them vs Runpod's