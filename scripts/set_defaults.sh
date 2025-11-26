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
if [[ ! -d "${FONTS_PATH}" ]] && [[ "$FULL_INSTALLATION" == true ]]; then
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

# Tealdeer
log "${CYAN}" "Tealdeer "
tldr --update

# Yazi
ya pkg install
if [[ ! -d "${YAZI_SMART_PASTE_PATH}" ]]; then
  mkdir --parents "${YAZI_SMART_PASTE_PATH}"
  cat >"$YAZI_SMART_PASTE_PATH/main.lua"<<-EOF
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
