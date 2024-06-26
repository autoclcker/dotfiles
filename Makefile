all: help
.PHONY: all

CONFIG_ARR = alacritty codium ctop dwm htop keybindings kitty k9s monkeytype nvim tmux wireshark/profiles
HOME_ARR   = .bashrc .gitconfig .profile .tool-versions .zshrc

git/stage: ### Stage configurations
	@git add  */.*
.PHONY: git/stage

sync: ### Synchronize configurations
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@gawk '{ print $$1 }' .tool-versions | xargs -I{} asdf plugin-add {} >/dev/null
	@asdf install | grep --invert-match 'already' || true
.PHONY: sync

help: ## Display this help screen
	@gawk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
	${MAKEFILE_LIST}
.PHONY: help

