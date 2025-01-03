alias lt='eza -T --color=always --icons=always'

if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

# Mise
eval "$(~/.local/bin/mise activate bash)"

# Zoxide
eval "$(zoxide init bash)"

# Fzf
eval "$(fzf --bash)"

# Thefuck
eval "$(thefuck --alias)"

export PS1="\[\033[01;32m\]\W\[\033[00;37m\] "
