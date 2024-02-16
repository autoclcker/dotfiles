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
alias ip='ip -c=always'
alias du='ncdu'
alias cat='batcat'
alias df='duf'
alias fd='fdfind'
alias http='http -v'
alias wp='nmcli device wifi show-password'
alias wtr='curl wttr.in/Petersburg'
alias e='nvim'
alias k='kubectl'
alias s='systemctl'
alias j='journalctl'
alias sem='docker run --rm -v "$(pwd):/$(pwd)" gittools/gitversion:5.12.0-alpine.3.14-6.0 /$(pwd) /showVariable FullSemVer'
alias gol='golangci-lint run --enable-all'
alias rd='rm -rf'

# Git
# git config --global alias.lo = log --pretty=oneline --abbrev-commit
# git config --global alias.alias "! git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /"

# Editor
export EDITOR="nvim"

# Manpager
export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# Fzf
export FZF_DEFAULT_OPTS='-m --height 30% --layout=reverse --border --inline-info'
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"

export PATH=$PATH:/usr/local/go/bin:~/go/bin
