# Checking if Cuda is avaliable:
https://www.patreon.com/posts/how-to-deploy-on-97919576?utm_medium=clipboard_copy&utm_source=copyLink&utm_campaign=postshare_creator&utm_content=join_link

```
import torch

# Check if CUDA (GPU) is available
if torch.cuda.is_available():
    # Get the number of available CUDA devices
    num_cuda_devices = torch.cuda.device_count()
    print(f"Number of CUDA devices available: {num_cuda_devices}")

    # Print information about each CUDA device
    for i in range(num_cuda_devices):
        device = torch.device(f'cuda:{i}')
        print(f"CUDA Device {i}: {torch.cuda.get_device_name(i)}")
        print(f"Device properties: {torch.cuda.get_device_properties(i)}")
        
    # Set a default device to the first CUDA device (GPU 0)
    torch.cuda.set_device(0)
    
    # Verify if CUDA is working by performing a simple operation on the GPU
    a = torch.tensor([1.0], device="cuda")
    b = torch.tensor([2.0], device="cuda")
    c = a + b
    print(f"Result of GPU computation: {c.item()}")
else:
    print("No CUDA devices available. Make sure you have a compatible GPU and PyTorch with CUDA support installed.")
```
