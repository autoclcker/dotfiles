#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}

CHEATSHEETS_REPO=${CHEATSHEETS_REPO:-"https://github.com/cheat/cheatsheets.git"}
HELM_DIFF_REPO=${HELM_DIFF_REPO:-"https://github.com/databus23/helm-diff"}
NERD_FONTS_REPO=${NERD_FONTS_REPO:-"https://github.com/ryanoasis/nerd-fonts.git"}
UEBERZUGPP_REPO=${UEBERZUGPP_REPO:-"https://github.com/jstkdng/ueberzugpp.git"}
ZSH_AUTOSUGGESTIONS_REPO=${ZSH_AUTOSUGGESTIONS_REPO:-"https://github.com/zsh-users/zsh-autosuggestions.git"}
ZSH_SYNTAX_HIGHLIGHTING_REPO=${ZSH_SYNTAX_HIGHLIGHTING_REPO:-"https://github.com/zsh-users/zsh-syntax-highlighting.git"}

FONTS=("DejaVuSansMono" "FiraCode" "Hack")
FONTS_PATH=${FONTS_PATH:-"$HOME/.local/share/fonts/nerd-fonts"}

WORKSPACES_COUNT=${WORKSPACES_COUNT:-9}

YAZI_SMART_PASTE_PATH=${YAZI_SMART_PASTE_PATH:-"$XDG_CONFIG_HOME/yazi/plugins/smart-paste.yazi"}

export PATH="$HOME/.local/share/mise/shims:$PATH"

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Ghostty
if realpath x-terminal-emulator | grep --quiet --invert-match "ghostty"; then
  ghostty=$(which ghostty)
  sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$ghostty" 50
  sudo update-alternatives --set x-terminal-emulator "$ghostty"
else
  printf "\e[1;96m%s\e[0m\n" "Ghostty is already default terminal"
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

# Helm
if [[ ! $(helm diff version) ]]; then
  helm plugin install "${HELM_DIFF_REPO}"
else
  printf "\e[1;96m%s\e[0m\n" "Helm diff is already installed"
fi

# GNOME
if env | grep --quiet "XDG_CURRENT_DESKTOP=.*GNOME"; then
  gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super>u']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group "['<Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "['<Shift><Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>period']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Super>comma']"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Super>backspace']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>bracketright']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super>bracketleft']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>z']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-on-all-workspaces "['<Super>m']"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces "$WORKSPACES_COUNT"
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.mutter workspaces-only-on-primary false
  gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>c']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>t']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>f']"
  gsettings set org.gnome.shell.extensions.pop-cosmic overlay-key-action 'LAUNCHER'
  gsettings set org.gnome.shell.extensions.pop-shell tile-orientation "['<Super>r']"
  gsettings set org.gnome.shell.keybindings toggle-message-tray "['Help']"
  gsettings set org.gnome.shell.keybindings toggle-overview "['LaunchA']"
  for ((i = 1; i <= "$WORKSPACES_COUNT"; i++)); do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$i']"
  done
  printf "\e[1;96m%s\e[0m\n" "GNOME is configured"
fi

# Tealdeer
printf "\e[1;96m%s\e[0m" "Tealdeer "
tldr --update

# Ueberzugpp
if [[ ! $(ueberzug --version) ]]; then
  git clone --depth 1 "${UEBERZUGPP_REPO}" /tmp/ueberzugpp && mkdir "$_/build"
  pushd "$_" || exit 1
  cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_TURBOBASE64=ON ..
  cmake --build .
  sudo cmake --install .
else
  printf "\e[1;96m%s\e[0m\n" "Ueberzugpp is already installed"
fi

# Yazi
ya pkg install
if [[ ! -d "${YAZI_SMART_PASTE_PATH}" ]]; then
  mkdir --parents "${YAZI_SMART_PASTE_PATH}"
  cat <<EOF >"$YAZI_SMART_PASTE_PATH/main.lua"
--- @sync entry
return {
	entry = function()
		local h = cx.active.current.hovered
		if h and h.cha.is_dir then
			ya.manager_emit("enter", {})
			ya.manager_emit("paste", {})
			ya.manager_emit("leave", {})
		else
			ya.manager_emit("paste", {})
		end
	end,
}
EOF
fi
printf "\e[1;96m%s\e[0m\n" "Yazi is configured"

# ZSH
zsh -c "zstyle ':omz:update' mode disabled"
if [[ ! -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
  git clone --depth 1 "${ZSH_AUTOSUGGESTIONS_REPO}" "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  git clone --depth 1 "${ZSH_SYNTAX_HIGHLIGHTING_REPO}" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
  printf "\e[1;96m%s\e[0m\n" "ZSH plugins are already installed"
fi

exit 0
