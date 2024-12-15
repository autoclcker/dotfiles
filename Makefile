all: help
.PHONY: all

HOME_ARR   = .bash_aliases .bashrc .gitconfig .profile .vimrc .zlogin .zshrc
CONFIG_ARR = alacritty cheat copyq dive k9s lazydocker lazygit mise nvim pop-shell procps procs ranger tmux wireshark/profiles

CONFIG_DIR = ${PWD}/.config
XDG_CONFIG_HOME = ${HOME}/.config

download:
	@./scripts/download_core_apps.sh --packages ${PWD}/deps/packages.txt
.PHONY: download

git/stage: ### Stage configurations
	@git add  */.*
.PHONY: git/stage

install: download sync ### Install setup
	@./scripts/set_defaults.sh
.PHONY: install

regress: ### Validate Setup integrity
	@docker buildx build --tag regress --file Dockerfile.regress .
	@docker rmi regress:latest
.PHONY: regress

sync: ### Synchronize configurations
	@./scripts/synchronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${CONFIG_DIR} --destination ${XDG_CONFIG_HOME} ${CONFIG_ARR}
	@./scripts/install_tools.sh
.PHONY: sync

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
	${MAKEFILE_LIST}
.PHONY: help
