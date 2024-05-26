# MY ALIAS
if [ "echo $0" = "bash" ]; then
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
alias z='zoxide'
alias sem='docker run --rm -v "$(pwd):/$(pwd)" gittools/gitversion:5.12.0-alpine.3.14-6.0 /$(pwd) /showVariable FullSemVer'
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
export FZF_BASE=/opt/fzf
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'"
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS='-m --height 30% --layout=reverse --border --inline-info'
export GOBIN=~/go/bin/
export PATH="$PATH:$GOBIN"
