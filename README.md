# gpu-passthrough-scripts
Contains a script for rebinding your GPU, and for deterministically running applications on your faster GPU. 

# Installation
Clone this repo, and cd and copy to /usr/bin
```shell
git clone https://github.com/alexankitty/fastgpu.git
cd fastgpu
sudo cp fastgpu /usr/bin
sudo chmod +x /usr/bin/fastgpu
```
If you intend to also use your GPU for a gaming VM, be sure to follow [this wiki page](https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Isolating_the_GPU) on how to statically bind your GPU to VFIO.  
If you need to hook your VM as well, a hooks installer script is included. Be sure to alter the scripts as needed. Change line 6 of hooks/qemu to the name of your VM from win11.

# Usage
Before any program launch or in steam, prepend fastgpu to use your faster graphics accelerator.  
If your faster GPU is unavailable (as a gpu pass through for example) it will use your primary GPU instead.
If environment variables are needed prior to the launch, the script has some magic to export them out, but requires that you wrap it in quotes.  
Example:
```shell
fastgpu 'WINEDLLOVERRIDES="dinput8,dll=n,b"' %command%
```
If you're not using steam, then you'll just replace %command% with your actual command.

# Important Note
Your compositor under wayland needs to support dynamic compositing to whichever is determined to be the primary/output/active GPU. See [this issue](https://invent.kde.org/plasma/kwin/-/issues/46) for kwin's implementation/progress. Otherwise you will need to close any programs that have touched the GPU since attaching it. Check output of the following command.
```shell
fuser -v /dev/nvidia0
```

# Slow Application Loading
Certain applications by default will try to use the nvidia gpu first prior to whichever is the mesa GPU. Run these to fix it.
```shell
sudo mv /usr/share/glvnd/egl_vendor.d/50_mesa.json /usr/share/glvnd/egl_vendor.d/10_mesa.json
sudo mv /usr/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/50_nvidia.json
```
This should alleviate the problem of applications using the wrong gpu and make it easier to unbind.

# Alterations
The assumption here is that you're using Nvidia under wayland as a prime offload GPU.  
Further details on how to achieve other configs can be found at [this archwiki page](https://wiki.archlinux.org/title/PRIME).    
A brief run down of changes that need to be made:  
On line 2, you need to change the module you're checking on from nvidia to amdgpu if AMD is your offloader (no guarantee how well this will work).  
On line 3, you will need to put in the IOMMU PCI ID of your GPU. You can grab that using [this script](https://gist.github.com/r15ch13/ba2d738985fce8990a4e9f32d07c6ada).  
On line 25 you will want to change the following:  
```shell
export DRI_PRIME=pci-0000_01_00_0 __VK_LAYER_NV_optimus=NVIDIA_only __GLX_VENDOR_LIBRARY_NAME=nvidia
```
To:
```shell
export DRI_PRIME=pci-0000_06_00_0
```

# GPU Swapping from vfio to nvidia
Run this from TTY for best results!
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
