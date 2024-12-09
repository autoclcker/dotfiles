alias copy='xsel --input --clipboard'
alias dog='doggo'
alias e='nvim'
alias gol='golangci-lint run --enable-all'
alias ip='ip -c=always'
alias j='journalctl'
alias less='bat -p'
alias p='printf'
alias pgadmin='docker run --rm -p 5432:80 \
    -e "PGADMIN_DEFAULT_EMAIL=admin@gmail.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=admin" \
    -d dpage/pgadmin4
'
alias procsi='procs --watch --watch-interval 2'
alias procst='procs --tree'
alias s='systemctl'
alias wp='nmcli device wifi show-password'
alias wtr='curl wttr.in/Petersburg'

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
