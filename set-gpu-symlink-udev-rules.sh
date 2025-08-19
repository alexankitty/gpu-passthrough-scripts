SYMLINK_NAME="amd-gpu"
RULE_PATH="/etc/udev/rules.d/amd-gpu-dev-path.rules"
AMD_GPU_ID=$(lspci -d ::03xx | grep 'AMD' | cut -f1 -d' ')
UDEV_RULE="$(
  cat <<EOF
KERNEL=="card*", \
KERNELS=="0000:$AMD_GPU_ID", \
SUBSYSTEM=="drm", \
SUBSYSTEMS=="pci", \
SYMLINK+="dri/$SYMLINK_NAME"
EOF
)"
echo "$UDEV_RULE" | sudo tee "$RULE_PATH"

SYMLINK_NAME="nvidia-gpu"
RULE_PATH="/etc/udev/rules.d/nvidia-gpu-dev-path.rules"
NVIDIA_GPU_ID=$(lspci -d ::03xx | grep 'NVIDIA' | cut -f1 -d' ')
UDEV_RULE="$(
  cat <<EOF
KERNEL=="card*", \
KERNELS=="0000:$NVIDIA_GPU_ID", \
SUBSYSTEM=="drm", \
SUBSYSTEMS=="pci", \
SYMLINK+="dri/$SYMLINK_NAME"
EOF
)"
echo "$UDEV_RULE" | sudo tee "$RULE_PATH"
