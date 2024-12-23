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

rga-fzf() {
  RG_PREFIX="rga --files-with-matches"
  local file
  file="$(
    FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
      fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
      --phony -q "$1" \
      --bind "change:reload:$RG_PREFIX {q}" \
      --preview-window="70%:wrap"
  )" &&
    echo "opening $file" &&
    xdg-open "$file"
}

export PS1="\[\033[01;32m\]\W\[\033[00;37m\] "
