[[ $- != *i* ]] && return

MISE_PATH=${MISE_PATH:-"$HOME/.local/bin/mise"}

export PS1="\[\033[01;32m\]\W \[\e[0m\]"

alias la='ls --all'
alias ll='ls -l'
alias ls='ls --color=auto'

source $HOME/.profile

# Mise
eval "$(${MISE_PATH} activate bash)"

# Zoxide
eval "$(zoxide init bash)"

# Fzf
eval "$(fzf --bash)"

# Delta
eval "$(delta --generate-completion bash)"

# Thefuck
eval "$(thefuck --alias)"
