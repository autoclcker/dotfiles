#!/usr/bin/env bash

# shellcheck disable=SC1091
source "scripts/helpers.sh"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
TMUX_PLUGINS_HOME=${TMUX_PLUGINS_HOME:-"$XDG_CONFIG_HOME/tmux/plugins"}
ZSH_PLUGINS_HOME=${ZSH_PLUGINS_HOME:-"$HOME/.oh-my-zsh/custom/plugins"}

CHEATSHEETS_REPO=${CHEATSHEETS_REPO:-"https://github.com/cheat/cheatsheets.git"}
HELM_DIFF_REPO=${HELM_DIFF_REPO:-"https://github.com/databus23/helm-diff"}
NERD_FONTS_REPO=${NERD_FONTS_REPO:-"https://github.com/ryanoasis/nerd-fonts.git"}
TMUX_EASYMOTION_REPO=${TMUX_EASYMOTION_REPO:-"https://github.com/ddzero2c/tmux-easymotion.git"}
ZSH_AUTOSUGGESTIONS_REPO=${ZSH_AUTOSUGGESTIONS_REPO:-"https://github.com/zsh-users/zsh-autosuggestions.git"}
ZSH_SYNTAX_HIGHLIGHTING_REPO=${ZSH_SYNTAX_HIGHLIGHTING_REPO:-"https://github.com/zsh-users/zsh-syntax-highlighting.git"}

FONTS=("DejaVuSansMono" "FiraCode" "Hack")

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
if [[ "$FULL_INSTALLATION" == true ]] && [[ ! -d "${FONTS_PATH}" ]]; then
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
log "${CYAN}" "Yazi is configured\n"

# Tmux
if [[ $(tmux --version) ]] && [[ ! -d "${TMUX_PLUGINS_HOME}/tmux-easymotion" ]]; then
  mkdir --parents "$TMUX_PLUGINS_HOME"
  git clone --depth 1 "${TMUX_EASYMOTION_REPO}" "${TMUX_PLUGINS_HOME:-$TMUX_PLUGINS_HOME}/tmux-easymotion"
else
  log "${CYAN}" "Tmux plugins are already installed\n"
fi

# Zsh
if [[ $(zsh --version) ]] && [[ ! -d "${ZSH_PLUGINS_HOME}/zsh-autosuggestions" ]]; then
  sudo chsh --shell $(command -v zsh | xargs realpath) $(whoami)
  git clone --depth 1 "${ZSH_AUTOSUGGESTIONS_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-autosuggestions"
  git clone --depth 1 "${ZSH_SYNTAX_HIGHLIGHTING_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-syntax-highlighting"
else
  log "${CYAN}" "Zsh plugins are already installed\n"
fi

exit 0
