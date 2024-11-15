alias dog='doggo'
alias ip='ip -c=always'
alias less='bat -p'
alias wp='nmcli device wifi show-password'
alias wtr='curl wttr.in/Petersburg'
alias e='nvim'
alias s='systemctl'
alias j='journalctl'
alias p='printf'
alias gol='golangci-lint run --enable-all'
alias procsi='procs --watch --watch-interval 2'
alias procst='procs --tree'
alias pgadmin='docker run --rm -p 5432:80 \
    -e "PGADMIN_DEFAULT_EMAIL=admin@gmail.com" \
    -e "PGADMIN_DEFAULT_PASSWORD=admin" \
    -d dpage/pgadmin4
'

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

# PATH
export PATH="$HOME/.local/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"

# Zoxide
export ZOXIDE_CMD_OVERRIDE="cd"

# Cheat
export CHEAT_USE_FZF=true

# History
export HISTSIZE=100000
export SAVEHIST=100000
