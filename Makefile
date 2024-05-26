all: help
.PHONY: all

CONFIG_ARR = alacritty ctop dwm htop keybindings kitty k9s nvim tmux VSCodium/User/profiles wireshark/profiles
HOME_ARR   = .bashrc .gitconfig .profile .tool-versions .zshrc

apply: ### Apply configurations
	@./scripts/syncronize_configuration.sh --searchpath ${PWD}/.config --destination ${HOME}/.config ${CONFIG_ARR}
	@./scripts/syncronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
.PHONY: apply

sync: ### Synchronize configurations
	@./scripts/syncronize_configuration.sh --searchpath ${HOME}/.config --destination ${PWD}/.config ${CONFIG_ARR}
	@./scripts/syncronize_configuration.sh --searchpath ${HOME} --destination ${PWD} ${HOME_ARR}
.PHONY: sync

	#$(call synchronize_configuration_file,${HOME},${PWD},${HOME_ARR})
help: ## Display this help screen
	@gawk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	${MAKEFILE_LIST}
.PHONY: help

