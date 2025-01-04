#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

CHEATSHEETS_REPO=${CHEATSHEETS_REPO:-"https://github.com/cheat/cheatsheets.git"}
NERD_FONTS_REPO=${NERD_FONTS_REPO:-"https://github.com/ryanoasis/nerd-fonts.git"}
OUCH_REPO=${OUCH_REPO:-"https://github.com/ndtoan96/ouch.yazi.git"}
UEBERZUGPP_REPO=${UEBERZUGPP_REPO:-"https://github.com/jstkdng/ueberzugpp.git"}
ZSH_AUTOSUGGESTIONS_REPO=${ZSH_AUTOSUGGESTIONS_REPO:-"https://github.com/zsh-users/zsh-autosuggestions.git"}

FONTS=("DejaVuSansMono" "FiraCode" "Hack")
FONTS_PATH=${FONTS_PATH:-"$HOME/.local/share/fonts/nerd-fonts"}

WORKSPACES_COUNT=${WORKSPACES_COUNT:-9}

export PATH="$HOME/.local/share/mise/shims:$PATH"

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Alacritty
if realpath x-terminal-emulator | grep --quiet --invert-match "alacritty"; then
  alacritty=$(which alacritty)
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$alacritty" 50
  sudo update-alternatives --set x-terminal-emulator "$alacritty"
else
  printf "\e[1;96m%s\e[0m\n" "Alacritty is already default terminal"
fi

# Cheat
if [[ ! -d "${XDG_CONFIG_HOME}/cheat/cheatsheets/community" ]]; then
  git clone --depth 1 "${CHEATSHEETS_REPO}" "${XDG_CONFIG_HOME}/cheat/cheatsheets/community"
else
  printf "\e[1;96m%s\e[0m\n" "Cheatsheets are already installed"
fi

# Fonts
if [[ ! -d /usr/local/share/fonts/nerd-fonts ]]; then
  git clone --filter=blob:none --sparse "${NERD_FONTS_REPO}" "${FONTS_PATH}"
  pushd "$_" || exit 1
  for f in "${FONTS[@]}"; do
    git sparse-checkout add "patched-fonts/$f"
    ./install.sh "$f"
  done
else
  printf "\e[1;96m%s\e[0m\n" "Fonts are already installed"
fi

# GNOME
if env | grep --quiet "XDG_CURRENT_DESKTOP=.*GNOME"; then
  gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super>u']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group "['<Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "['<Shift><Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>period']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Super>comma']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>bracketright']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super>bracketleft']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>z']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-on-all-workspaces "['<Super>m']"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces "$WORKSPACES_COUNT"
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.mutter workspaces-only-on-primary false
  gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Shift><Super>comma']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>t']"
  for ((i = 1; i <= "$WORKSPACES_COUNT"; i++)); do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$i']"
  done
  sudo ln --symbolic --force /usr/bin/galculator /usr/bin/gnome-calculator
  printf "\e[1;96m%s\e[0m\n" "GNOME is configured"
fi

# Tealdeer
printf "\e[1;96m%s\e[0m" "Tealdeer "
tldr --update

# Ueberzugpp
if [[ -z $(ueberzug --version) ]]; then
  git clone --depth 1 "${UEBERZUGPP_REPO}" /tmp/ueberzugpp && mkdir "$_/build"
  pushd "$_" || exit 1
  cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_TURBOBASE64=ON ..
  cmake --build .
  sudo cmake --install .
else
  printf "\e[1;96m%s\e[0m\n" "Ueberzugpp is already installed"
fi

# YAZI
ya pack --install
if [[ ! -d "${XDG_CONFIG_HOME}/yazi/plugins/ouch.yazi" ]]; then
  git clone --depth 1 "${OUCH_REPO}" "${XDG_CONFIG_HOME}/yazi/plugins/ouch.yazi"
fi
printf "\e[1;96m%s\e[0m" "Yazi is configured"

# ZSH
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone --depth 1 "${ZSH_AUTOSUGGESTIONS_REPO}" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
  printf "\e[1;96m%s\e[0m\n" "ZSH-autosuggestions are already installed"
fi

exit 0
