all: help
.PHONY: all

CONFIG_ARR = "alacritty" "codium" "ctop" "htop" "keybindings" "kitty" "k9s" "nvim" "tmux" "wireshark/profiles"
HOME_ARR   = ".bashrc" ".gitconfig" ".profile" ".tool-versions" ".zshrc"

define synchronize_configuration
	@for i in ${3}; do \
		cp --recursive ${1}/$${i} ${2}; \
	done
endef

apply: ### Apply configurations
	$(call synchronize_configuration,.config,~/.config,${CONFIG_ARR})
	$(call synchronize_configuration,.,~/,${HOME_ARR})
.PHONY: apply

sync: ### Synchronize configurations
	$(call synchronize_configuration,~/.config,.config,${CONFIG_ARR})
	$(call synchronize_configuration,~/,.,${HOME_ARR})
.PHONY: sync

help: ## Display this help screen
	@gawk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	${MAKEFILE_LIST}
.PHONY: help

