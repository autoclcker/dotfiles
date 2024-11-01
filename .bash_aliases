alias lt='eza -T --color=always --icons=always'

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# Mise
eval "$(~/.local/bin/mise activate bash)"

# Zoxide
eval "$(zoxide init bash)"

# Fzf
eval "$(fzf --bash)"

export PS1="\[\033[01;32m\]\W\[\033[00;37m\] "
