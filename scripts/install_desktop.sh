#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

CLI_APPS=("docker" "docker-compose" "docker-buildx" "udiskie")
GUI_APPS=("copyq" "ghostty" "google-chrome" "vscodium-bin")
INTEL=("intel-media-driver" "intel-ucode" "mesa" "vulkan-intel")
NETWORK=("bluez" "bluez-utils" "networkmanager")
NVIDIA=("libva-nvidia-driver" "nvidia-open-dkms" "nvidia-settings" "nvidia-utils")
POWER_MANAGEMENT=("cpupower" "system76-acpi-dkms" "system76-power")
PREREQUISITES=("base-devel" "linux-headers" "man-pages" "man-db")
SOUND=("pipewire" "pipewire-alsa" "pipewire-pulse" "sof-firmware" "wireplumber")
WAYLAND_COMPOSITOR=("cosmic-session" "cosmic-wallpapers" "switcheroo")

APPS_SVC=("containerd" "docker")
DESKTOP_SVC=("cosmic-greeter" "switcheroo-control")
NETWORK_SVC=("bluetooth" "NetworkManager")
POWER_CONTROL_SVC=("com.system76.PowerDaemon" "cpupower")

APPS=("${CLI_APPS[@]}" "${GUI_APPS[@]}")
GPU=("${INTEL[@]}" "${NVIDIA[@]}")
SYSTEM_SVC=("${NETWORK_SVC[@]}" "${POWER_CONTROL_SVC[@]}")
SYSTEM=("${NETWORK[@]}" "${POWER_MANAGEMENT[@]}" "${SOUND[@]}")

PACKAGES=("${APPS[@]}" "${GPU[@]}" "${SYSTEM[@]}" "${WAYLAND_COMPOSITOR[@]}")
SERVICES=("${APPS_SVC[@]}" "${DESKTOP_SVC[@]}" "${SYSTEM_SVC[@]}")
UNITS=("${SERVICES[@]/%/.service}")

if [[ "$FULL_INSTALLATION" != true ]] || [[ ! $(yay --version) ]]; then
  log "${CYAN}" "Desktop Environment isn't needed\n"
  exit 0
fi

# Desktop Environment
yay --refresh --sync
yay --needed --noconfirm --sync "${PREREQUISITES[@]}"
yay --needed --noconfirm --sync "${PACKAGES[@]}"

# Systemd
for u in "${UNITS[@]}"; do
  sudo systemctl enable "$u"
done

# NVIDIA
if [[ ! $(nvidia-smi) ]]; then
  log "${CYAN}" "NVIDIA configuration isn't needed\n"
elif grep --quiet "__NV_PRIME_RENDER_OFFLOAD" /etc/environment; then
  log "${CYAN}" "NVIDIA is already configured\n"
else
  sudo tee --append /etc/environment <<EOF
GBM_BACKEND=nvidia-drm
CUDA_DISABLE_PERF_BOOST=1
__NV_PRIME_RENDER_OFFLOAD=1
__GLX_VENDOR_LIBRARY_NAME=nvidia
EOF
fi

exit 0
