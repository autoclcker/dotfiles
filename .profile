#!/usr/bin/env bash
if [[ "$0" == "/usr/bin/bash" ]]; then
  alias ll='ls -l'
  alias la='ls -a'
else
  alias ls='exa --color=always --icons'
  alias lt='exa -T --color=always --icons'
  alias ll='exa -lh --color=always --icons'
  alias la='exa -a --color=always --icons'
fi
alias ctop='TERM="${TERM/#tmux/screen}" ctop'
alias ip='ip -c=always'
alias http='http -v'
alias wp='nmcli device wifi show-password'
alias wtr='curl wttr.in/Petersburg'
alias e='nvim'
alias s='systemctl'
alias j='journalctl'
alias gol='golangci-lint run --enable-all'

# Tmux
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_DEFAULT_SESSION_NAME="main"

# Editor
export EDITOR="nvim"

# Manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Fzf
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="
	--preview 'echo {}' --preview-window up:3:hidden:wrap
	--bind 'ctrl-/:toggle-preview'"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="-m --height 30% --layout=reverse --border --inline-info"

# Zoxide
export ZOXIDE_CMD_OVERRIDE="cd"

# PATH
export GOBIN=~/go/bin/
export PATH="$PATH:$GOBIN"
export XDG_CONFIG_HOME="$HOME/.config"

# Lazygit
export LG_CONFIG_FILE="$XDG_CONFIG_HOME/lazygit/config.yaml"

# Cheat
export CHEAT_USE_FZF=true
