#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

CLI_APPS=("docker" "docker-compose" "docker-buildx" "udiskie")
GUI_APPS=("copyq" "ghostty" "google-chrome" "vscodium-bin")
INTEL=("intel-media-driver" "intel-ucode" "mesa" "vulkan-intel")
NETWORK=("bluez" "bluez-utils" "networkmanager")
NVIDIA=("libva-nvidia-driver" "nvidia-open-dkms" "nvidia-settings" "nvidia-utils")
POWER_MANAGEMENT=("system76-acpi-dkms" "system76-power")
PREREQUISITES=("base-devel" "linux-headers" "man-pages" "man-db")
SOUND=("pipewire" "pipewire-alsa" "pipewire-pulse" "sof-firmware" "wireplumber")
WAYLAND_COMPOSITOR=("cosmic-session" "cosmic-wallpapers" "switcheroo")

APPS=("${CLI_APPS[@]}" "${GUI_APPS[@]}")
GPU=("${INTEL[@]}" "${NVIDIA[@]}")
SYSTEM=("${NETWORK[@]}" "${POWER_MANAGEMENT[@]}" "${SOUND[@]}")

PACKAGES=("${APPS[@]}" "${GPU[@]}" "${SYSTEM[@]}" "${WAYLAND_COMPOSITOR[@]}")

if [[ ! $(yay --version) ]] || [[ "$FULL_INSTALLATION" != true ]]; then
  log "${CYAN}" "Desktop Environment isn't needed\n"
  exit 0
fi

# Desktop Environment
yay --refresh --sync
yay --needed --noconfirm --sync "${PREREQUISITES[@]}"
yay --needed --noconfirm --sync "${PACKAGES[@]}"

# Nvidia
if grep --quiet "__NV_PRIME_RENDER_OFFLOAD" /etc/environment; then
  log "${CYAN}" "Nvidia is already configured\n"
else
  sudo tee --append /etc/environment <<EOF
CUDA_DISABLE_PERF_BOOST=1
__NV_PRIME_RENDER_OFFLOAD=1
__GLX_VENDOR_LIBRARY_NAME=nvidia
EOF
fi

# Systemd
sudo systemctl enable bluetooth.service
sudo systemctl enable com.system76.PowerDaemon.service
sudo systemctl enable containerd.service
sudo systemctl enable cosmic-greeter.service
sudo systemctl enable docker.service
sudo systemctl enable NetworkManager.service
sudo systemctl enable switcheroo-control.service

exit 0
