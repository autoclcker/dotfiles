#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
TMUX_PLUGINS_HOME=${TMUX_PLUGINS_HOME:-"$XDG_CONFIG_HOME/tmux/plugins"}
ZSH_PLUGINS_HOME=${ZSH_PLUGINS_HOME:-"$HOME/.oh-my-zsh/custom/plugins"}

DOCKER_SBOM_URL=${DOCKER_SBOM_URL:-"https://raw.githubusercontent.com/docker/sbom-cli-plugin/main/install.sh"}
DOCKER_SLIM_URL=${DOCKER_SLIM_URL:-"https://raw.githubusercontent.com/slimtoolkit/slim/master/scripts/install-slim.sh"}
OH_MY_ZSH_URL=${OH_MY_ZSH_URL:-"https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"}

CHEATSHEETS_REPO=${CHEATSHEETS_REPO:-"https://github.com/cheat/cheatsheets.git"}
HELM_DIFF_REPO=${HELM_DIFF_REPO:-"https://github.com/databus23/helm-diff"}
NERD_FONTS_REPO=${NERD_FONTS_REPO:-"https://github.com/ryanoasis/nerd-fonts.git"}
TMUX_EASYMOTION_REPO=${TMUX_EASYMOTION_REPO:-"https://github.com/ddzero2c/tmux-easymotion.git"}
ZSH_AUTOSUGGESTIONS_REPO=${ZSH_AUTOSUGGESTIONS_REPO:-"https://github.com/zsh-users/zsh-autosuggestions.git"}
ZSH_SYNTAX_HIGHLIGHTING_REPO=${ZSH_SYNTAX_HIGHLIGHTING_REPO:-"https://github.com/zsh-users/zsh-syntax-highlighting.git"}

TZ=${TZ:-"Europe/Moscow"}

LOCALES=("en_US.UTF-8 UTF-8" "ru_RU.UTF-8 UTF-8")
TMUX_EASYMOTION_VERSION=${TMUX_EASYMOTION_VERSION:-"v1.2.2"}

HELM_DIFF_PATH=${HELM_DIFF_PATH:-"$HOME/.local/share/helm/plugins/helm-diff"}

export PATH="$HOME/.local/share/mise/shims:$PATH"

# Cheat
if [[ ! -d "${XDG_CONFIG_HOME}/cheat/cheatsheets/community" ]]; then
  git clone --depth 1 "${CHEATSHEETS_REPO}" "${XDG_CONFIG_HOME}/cheat/cheatsheets/community"
else
  log "${CYAN}" "Cheatsheets are already installed\n"
fi

# CopyQ
if [[ "$IS_FULL_INSTALLATION" != true ]]; then
  log "${CYAN}" "CopyQ are not needed\n"
elif [[ ! $(dotool --version) ]]; then
  log "${YELLOW}" "Warning: dotool is not installed\n"
else
  sudo groupadd --force input
  sudo usermod --append --groups input "${USER}"
fi

# Time
sudo ln --symbolic --force /usr/share/zoneinfo/"${TZ}" /etc/localtime
if [[ "$IS_FULL_INSTALLATION" = true ]]; then
  sudo hwclock --systohc
fi

# Locales&Manuals
if [[ "$IS_FULL_INSTALLATION" != true ]]; then
  log "${CYAN}" "Fonts&Locales are not needed\n"
elif grep --extended-regexp --invert-match --quiet '^(#|$)' /etc/locale.gen; then
  for l in "${LOCALES[@]}"; do
    sudo sed --in-place "s/^#\($l\)/\1/" /etc/locale.gen
  done
  sudo locale-gen
  sudo mandb
else
  log "${CYAN}" "Locales&Manual are already configured\n"
fi

# Docker
if [[ "$IS_FULL_INSTALLATION" != true ]]; then
  log "${CYAN}" "No Docker configuration is required\n"
elif [[ ! $(docker --version) ]]; then
  log "${YELLOW}" "Warning: Docker is not installed\n"
elif [[ ! $(slim --version) ]]; then
  sudo usermod --append --groups docker "${USER}"
  sudo mkdir --parents /etc/docker && sudo touch "$_/daemon.json"
  sudo tee /etc/docker/daemon.json <<EOF
{
  "features": {
    "cdi": true,
    "containerd-snapshotter": true
  }
}
EOF
  mkdir --parents "$HOME/.docker"
  curl --connect-timeout "${CONNECTION_TIMEOUT_SEC}" \
      --show-error \
      --location \
      --silent \
      --fail \
      "$DOCKER_SBOM_URL" | sh -s --
  curl --connect-timeout "${CONNECTION_TIMEOUT_SEC}" \
      --location \
      --silent \
      --fail \
      "$DOCKER_SLIM_URL" | sudo --preserve-env sh -
else
  log "${CYAN}" "No Docker configuration is required\n"
fi

# Helm
if [[ ! $(helm version) ]]; then
  log "${YELLOW}" "Warning: Helm is not installed\n"
elif [[ ! -d "${HELM_DIFF_PATH}" ]]; then
  helm plugin install --verify=false "${HELM_DIFF_REPO}"
else
  log "${CYAN}" "Helm diff is already installed\n"
fi

# Tealdeer
tldr --update &>/dev/null || log "${YELLOW}" "Warning: Tealdeer is not installed\n"

# Yazi
ya pkg install &>/dev/null || log "${YELLOW}" "Warning: Yazi is not installed\n"

# Tmux
if [[ ! $(tmux -V) ]]; then
  log "${YELLOW}" "Warning: Tmux is not installed\n"
elif [[ ! -d "${TMUX_PLUGINS_HOME}/tmux-easymotion" ]]; then
  mkdir --parents "$TMUX_PLUGINS_HOME"
  pushd "$_" || exit 1
  git clone --depth 1 --branch "${TMUX_EASYMOTION_VERSION}" "${TMUX_EASYMOTION_REPO}"
else
  log "${CYAN}" "Tmux plugins are already installed\n"
fi

# Zsh
if [[ ! $(zsh --version) ]]; then
  log "${YELLOW}" "Warning: Zsh is not installed\n"
elif [[ ! -d "${ZSH_PLUGINS_HOME}/zsh-autosuggestions" ]]; then
  sudo chsh --shell "$(command -v zsh | xargs realpath)" "$(whoami)"
  sh -c "$(curl --connect-timeout "${CONNECTION_TIMEOUT_SEC}" \
                --show-error \
                --location \
                --silent \
                --fail \
                "$OH_MY_ZSH_URL") --unattended"
  git clone --depth 1 "${ZSH_AUTOSUGGESTIONS_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-autosuggestions"
  git clone --depth 1 "${ZSH_SYNTAX_HIGHLIGHTING_REPO}" "${ZSH_PLUGINS_HOME:-$ZSH_PLUGINS_HOME}/zsh-syntax-highlighting"
else
  log "${CYAN}" "Zsh is already configured\n"
fi

exit 0
