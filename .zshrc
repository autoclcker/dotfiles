export ZSH="$HOME/.oh-my-zsh"

zstyle ':omz:update' mode disabled
plugins=(
	aliases
	ansible
	ant
	bazel
	command-not-found
	copyfile
	dircycle
	fancy-ctrl-z
	fzf
	git
	git-commit
	golang
	helm
	kubectl
	mise
	mvn
	nmap
	npm
	pip
	python
	rust
	ssh
	starship
	sudo
	systemadmin
	systemd
	tmux
	zoxide
	zsh-autosuggestions
	zsh-syntax-highlighting
)

alias grep='rg'
alias la='eza --all --color=always --icons=always'
alias ll='eza --long --group --git --header --color=always --icons=always'
alias lR='eza --tree --color=always --icons=always'
alias ls='eza --color=always --icons=always'

source "$HOME/.profile"
source "$ZSH/oh-my-zsh.sh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e6e6e,bg=#000000,bold"
PROMPT_EOL_MARK=''
bindkey '^ ' autosuggest-accept
bindkey "^U" backward-kill-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

precmd () {
	echo -n -e "\a"
}

# Delta
eval "$(delta --generate-completion zsh)"
