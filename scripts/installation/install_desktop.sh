#!/usr/bin/env bash

BROWSERS=("brave-bin" "google-chrome")
CLI_APPS=("docker" "docker-compose" "docker-buildx" "dotool" "udiskie")
GUI_APPS=("${BROWSERS[@]}" "copyq" "ghostty" "vscodium-bin" "wireshark-qt")
INTEL=("intel-media-driver" "intel-ucode" "mesa" "vpl-gpu-rt" "vulkan-intel")
NETWORK=("bluez" "bluez-utils" "networkmanager")
NVIDIA=("libva-nvidia-driver" "nvidia-open-dkms" "nvidia-settings" "nvidia-utils")
POWER_MANAGEMENT=("cpupower" "system76-acpi-dkms" "system76-power" "upower")
PREREQUISITES=("linux-headers" "man-pages" "man-db")
SOUND=("pipewire" "pipewire-alsa" "pipewire-pulse" "sof-firmware" "wireplumber")
UX_RESPONSIVENESS=("switcheroo" "system76-scheduler")
WAYLAND_COMPOSITOR=("cosmic-session" "cosmic-wallpapers")

APPS_SVC=("containerd" "docker")
AUTOSTART_SVC=("dotool" "udiskie")
DESKTOP_SVC=("com.system76.Scheduler" "cosmic-greeter" "switcheroo-control")
NETWORK_SVC=("bluetooth" "NetworkManager")
POWER_CONTROL_SVC=("com.system76.PowerDaemon" "cpupower")

APPS=("${CLI_APPS[@]}" "${GUI_APPS[@]}")
GPU=("${INTEL[@]}" "${NVIDIA[@]}")
SYSTEM_SVC=("${NETWORK_SVC[@]}" "${POWER_CONTROL_SVC[@]}")
SYSTEM=("${NETWORK[@]}" "${POWER_MANAGEMENT[@]}" "${SOUND[@]}" "${UX_RESPONSIVENESS[@]}")

PACKAGES=("${APPS[@]}" "${GPU[@]}" "${SYSTEM[@]}" "${WAYLAND_COMPOSITOR[@]}")
PATHS=("downloads-demux")
SERVICES=("${APPS_SVC[@]}" "${DESKTOP_SVC[@]}" "${SYSTEM_SVC[@]}")
UNITS=("${SERVICES[@]/%/.service}")
USER_UNITS=("${AUTOSTART_SVC[@]/%/.service}" "${PATHS[@]/%/.path}")

if [[ "$IS_FULL_INSTALLATION" != true ]]; then
  log "${CYAN}" "Desktop Environment isn't needed\n"
  exit 0
elif [[ ! $(yay --version) ]]; then
  log "${RED}" "Error: yay is not installed\n"
  exit 1
else
  log "${CYAN}" "Desktop Environment installation started\n"
  trap log_completion EXIT
  trap log_interruption INT
fi

# Desktop Environment
yay --refresh --sync || exit $?
yay --needed --noconfirm --removemake --sync "${PREREQUISITES[@]}" || exit $?
yay --needed --noconfirm --removemake --sync "${PACKAGES[@]}" || exit $?

# Systemd
for u in "${UNITS[@]}"; do
  sudo systemctl enable "$u"
done
for u in "${USER_UNITS[@]}"; do
  systemctl --user enable "$u"
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
