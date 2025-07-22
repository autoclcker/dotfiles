alias grep='rg'
alias lR='eza --tree --color=always --icons=always'

if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

d() {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}

# Mise
eval "$(~/.local/bin/mise activate bash)"

# Zoxide
eval "$(zoxide init bash)"

# Fzf
eval "$(fzf --bash)"

# Delta
eval "$(delta --generate-completion bash)"

# Thefuck
eval "$(thefuck --alias)"

export PS1="\[\033[01;32m\]\W\[\033[00;37m\] "
