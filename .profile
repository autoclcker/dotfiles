alias copy='xsel --input --clipboard'
alias diffo='diffoci diff --semantic'
alias dog='doggo'
alias e='nvim'
alias gol='golangci-lint run --enable-all'
alias ip='ip -color=always'
alias j='journalctl'
alias kc='kubectx'
alias less='bat -p'
alias p='printf'
alias pgadmin='docker run --rm -p 5432:80 \
    --env "PGADMIN_DEFAULT_EMAIL=admin@gmail.com" \
    --env "PGADMIN_DEFAULT_PASSWORD=admin" \
    --name pgadmin4 \
    --detach dpage/pgadmin4
'
alias procsi='procs --watch --watch-interval 2'
alias procst='procs --tree'
alias s='systemctl'
alias ungron="gron --ungron"
alias wp='nmcli device wifi show-password'
alias wtr='curl wttr.in/Petersburg'

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
    printf "opening %s" "$file" &&
    xdg-open "$file"
}

y() {
  local tmp
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  local cwd=$tmp
  yazi "$@" --cwd-file="$tmp"
  printf "\x1b[\x35 q" # change cursor to steady bar
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    pushd -- "$cwd" || exit 1
  fi
  rm -f -- "$tmp"
}

djwt() {
  printf "$@" | jq --raw-input 'split(".") | .[0],.[1] | @base64d | fromjson'
}

# Editor
export EDITOR="nvim"

# Manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Fzf
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_R_OPTS="
	--preview 'echo {}' --preview-window up:3:hidden:wrap
	--bind 'ctrl-y:execute-silent(echo -n {2..} | xsel --input --clipboard)+abort'
	--bind 'ctrl-/:toggle-preview'
	--color header:italic"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="-m --height 30% --layout=reverse --border --inline-info"

# Tmux
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_DEFAULT_SESSION_NAME="main"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# MISE
export PATH="$HOME/.local/bin:$PATH"

# Zoxide
export ZOXIDE_CMD_OVERRIDE="cd"

# Cheat
export CHEAT_USE_FZF=true

# History
export HISTSIZE=100000
export SAVEHIST=100000
