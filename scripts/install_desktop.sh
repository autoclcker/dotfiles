#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

APPS=("copyq" "docker" "ghostty" "google-chrome" "vscodium-bin")
NETWORK=("bluez" "bluez-utils" "networkmanager")
NVIDIA=("nvidia-dkms")
PREREQUISITES=("base-devel" "linux-headers" "man-pages" "man-db")
SOUND=("pipewire" "pipewire-alsa" "pipewire-pulse" "sof-firmware" "wireplumber")
WAYLAND_COMPOSITOR=("cosmic-session" "system76-power")

PACKAGES=("${APPS[@]}" "${NETWORK[@]}" "${NVIDIA[@]}" "${SOUND[@]}" "${WAYLAND_COMPOSITOR[@]}")

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

exit 0
