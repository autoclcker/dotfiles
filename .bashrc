[[ $- != *i* ]] && return

export PS1="\[\033[01;32m\]\W \[\e[0m\]"

alias la='ls --all'
alias ll='ls -l'
alias ls='ls --color=auto'

# shellcheck disable=SC1091
source "$HOME/.profile"

# Delta
eval "$(delta --generate-completion bash)"

# Fzf
eval "$(fzf --bash)"

# just
eval "$(just --completions bash)"

# Zoxide
eval "$(zoxide init bash)"
