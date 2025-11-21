#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
ZSH_PLUGINS_HOME=${ZSH_PLUGINS_HOME:-"$HOME/.oh-my-zsh/custom/plugins"}

CHEATSHEETS_REPO=${CHEATSHEETS_REPO:-"https://github.com/cheat/cheatsheets.git"}
HELM_DIFF_REPO=${HELM_DIFF_REPO:-"https://github.com/databus23/helm-diff"}
NERD_FONTS_REPO=${NERD_FONTS_REPO:-"https://github.com/ryanoasis/nerd-fonts.git"}
ZSH_AUTOSUGGESTIONS_REPO=${ZSH_AUTOSUGGESTIONS_REPO:-"https://github.com/zsh-users/zsh-autosuggestions.git"}
ZSH_SYNTAX_HIGHLIGHTING_REPO=${ZSH_SYNTAX_HIGHLIGHTING_REPO:-"https://github.com/zsh-users/zsh-syntax-highlighting.git"}

WORKSPACE_INDEXES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "minus" "equal")

FONTS=("DejaVuSansMono" "FiraCode" "Hack")

YAZI_SMART_PASTE_PATH=${YAZI_SMART_PASTE_PATH:-"$XDG_CONFIG_HOME/yazi/plugins/smart-paste.yazi"}

FONTS_PATH=${FONTS_PATH:-"$HOME/.local/share/fonts/nerd-fonts"}
HELM_DIFF_PATH=${HELM_DIFF_PATH:-"$HOME/.local/share/helm/plugins/helm-diff"}

export PATH="$HOME/.local/share/mise/shims:$PATH"

# Cheat
if [[ ! -d "${XDG_CONFIG_HOME}/cheat/cheatsheets/community" ]]; then
  git clone --depth 1 "${CHEATSHEETS_REPO}" "${XDG_CONFIG_HOME}/cheat/cheatsheets/community"
else
  log "${CYAN}" "Cheatsheets are already installed\n"
fi

# Fonts&Locales
if [[ ! -d "${FONTS_PATH}" ]]; then
  git clone --filter=blob:none --sparse "${NERD_FONTS_REPO}" "${FONTS_PATH}"
  pushd "$_" || exit 1
  for f in "${FONTS[@]}"; do
    git sparse-checkout add "patched-fonts/$f"
    ./install.sh "$f"
  done
  sudo vim /etc/locale.gen
  sudo locale-gen
  sudo mandb
else
  log "${CYAN}" "Fonts&Locales are already installed\n"
fi

# Helm
if [[ ! -d "${HELM_DIFF_PATH}" ]]; then
  helm plugin install --verify=false "${HELM_DIFF_REPO}"
else
  log "${CYAN}" "Helm diff is already installed\n"
fi

# TODO: keybindings
if env | grep --quiet "XDG_CURRENT_DESKTOP=.*GNOME"; then
  gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Super>u']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group "['<Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-group-backward "['<Shift><Super>apostrophe']"
  gsettings set org.gnome.desktop.wm.keybindings maximize-horizontally "['<Alt><Super>s']"
  gsettings set org.gnome.desktop.wm.keybindings maximize-vertically "['<Alt><Super>v']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group "['<Super>bracketright']"
  gsettings set org.gnome.desktop.wm.keybindings switch-group-backward "['<Super>bracketleft']"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
  gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['<Super>backspace']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>n']"
  gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Super>b']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>z']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt><Super>z']"
  gsettings set org.gnome.desktop.wm.keybindings toggle-on-all-workspaces "['<Super>m']"
  gsettings set org.gnome.desktop.wm.preferences num-workspaces "${#WORKSPACE_INDEXES[@]}"
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.mutter workspaces-only-on-primary false
  gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Super>comma']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "['<Super>t']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>f']"
  gsettings set org.gnome.shell.extensions.pop-cosmic overlay-key-action 'LAUNCHER'
  gsettings set org.gnome.shell.extensions.pop-shell tile-orientation "['<Super>r']"
  gsettings set org.gnome.shell.keybindings toggle-message-tray "['Help']"
  gsettings set org.gnome.shell.keybindings toggle-overview "['LaunchA']"
  for ((i = 0; i <= ${#WORKSPACE_INDEXES[@]} - 1; i++)); do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-"$((i + 1))" "['<Super>${WORKSPACE_INDEXES[$i]}']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-"$((i + 1))" "['<Super><Shift>${WORKSPACE_INDEXES[$i]}']"
  done
  log "${CYAN}" "GNOME is configured\n"
fi

# Tealdeer
log "${CYAN}" "Tealdeer "
tldr --update

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
log "${CYAN}" "Yazi is configured\n"

# Zsh
if [[ $(zsh --version) ]] && [[ ! -d "${ZSH_PLUGINS_HOME}/zsh-autosuggestions" ]]; then
  git clone --depth 1 "${ZSH_AUTOSUGGESTIONS_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-autosuggestions"
  git clone --depth 1 "${ZSH_SYNTAX_HIGHLIGHTING_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-syntax-highlighting"
else
  log "${CYAN}" "Zsh plugins are already installed\n"
fi

exit 0
