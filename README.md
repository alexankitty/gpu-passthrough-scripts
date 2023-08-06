# fastgpu
Runs a program using your fast GPU as an offloader.

# Installation
Clone this repo, and cd and copy to /usr/bin
```shell
git clone https://github.com/alexankitty/fastgpu.git
cd fastgpu
sudo cp fastgpu /usr/bin
sudo chmod +x /usr/bin/fastgpu
```

# Usage
Before any program launch or in steam, prepend fastgpu to use your faster graphics accelerator.  
If your faster GPU is unavailable (as a gpu pass through for example) it will use your primary GPU instead.
If environment variables are needed prior to the launch, the script has some magic to export them out, but requires that you wrap it in quotes.  
Example:
```shell
fastgpu 'WINEDLLOVERRIDES="dinput8,dll=n,b"' %command%
```
If you're not using steam, then you'll just replace %command% with your actual command.

# Alterations
The assumption here is that you're using Nvidia under wayland as a prime offload GPU.  
Further details on how to achieve other configs can be found at [this archwiki page](https://wiki.archlinux.org/title/PRIME).    
A brief run down of changes that need to be made:  
On line 2, you need to change the module you're checking on from nvidia to amdgpu if AMD is your offloader (no guarantee how well this will work).  
On line 25 you will want to change the following:  
```shell
export DRI_PRIME=pci-0000_01_00_0 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia
```
To:
```shell
export DRI_PRIME=pci-0000_06_00_0
```

# GPU Swapping from vfio to nvidia
## Install
```shell
sudo cp swapgpu /usr/bin
sudo chmod +x /usr/bin/swapgpu
```
Change the following to match your setup.
```shell
gpu_id="0000:01:00.0"
gpu_audio_id="0000:01:00.1"
```
If you're on AMD I recommend looking through [this reddit post](https://www.reddit.com/r/VFIO/comments/gxyvtg/comment/ft965p6/) for actually adjusting the script for AMD. 

## Usage
```
sudo swapgpu nvidia # swaps to nvidia
sudo swapgpu vfio-pci # swaps to vfio for binding to VM
```
