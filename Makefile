all: help
.PHONY: all

HOME_ARR   = .bashrc .gitconfig .profile .vimrc .zshrc
CONFIG_ARR = alacritty cheat codium dive htop keybindings k9s lazygit mise monkeytype nvim procps ranger tmux wireshark/profiles

download:
	@./scripts/download_core_apps.sh
.PHONY: download

git/stage: ### Stage configurations
	@git add  */.*
.PHONY: git/stage

install: download sync ### Install setup
.PHONY: install

sync: ### Synchronize configurations
	@./scripts/synchronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_ARR}
	@mise install
.PHONY: sync

help: ## Display this help screen
	@gawk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
	${MAKEFILE_LIST}
.PHONY: help
