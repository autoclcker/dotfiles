export ZSH="$HOME/.oh-my-zsh"

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
	podman
	procs
	python
	rust
	ssh
	starship
	sudo
	systemadmin
	systemd
	thefuck
	tldr
	tmux
	zoxide
	zsh-autosuggestions
	zsh-syntax-highlighting
)

# Common aliases
source ~/.profile

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6e6e6e,bg=#000000,bold"
PROMPT_EOL_MARK=''
bindkey '^ ' autosuggest-accept
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M emacs '^[[28;5;9~' sudo-command-line
bindkey -M vicmd '^[[28;5;9~' sudo-command-line
bindkey -M viins '^[[28;5;9~' sudo-command-line

# User configuration
export LANG=en_US.UTF-8

precmd () {
	echo -n -e "\a"
}

