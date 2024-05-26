all: help
.PHONY: all

CONFIG_ARR = "alacritty" "ctop" "htop" "keybindings" "kitty" "k9s" "nvim" "tmux" "VSCodium/User/profiles" "wireshark/profiles"
HOME_ARR   = ".bashrc" ".gitconfig" ".profile" ".tool-versions" ".zshrc"

define synchronize_configuration_dir
	@for i in ${3}; do \
		rsync --archive --inplace --relative ${1}/$${i} ${2}; \
	done
endef

define synchronize_configuration_file
	@for i in ${3}; do \
		rsync --archive --inplace ${1}/$${i} ${2}; \
	done
endef
		#printf "%s %s %s\n" ${1} $${i} ${2}; \
	
apply: ### Apply configurations
	$(call synchronize_configuration_dir,.config,${HOME},${CONFIG_ARR})
	$(call synchronize_configuration_file,${PWD},${HOME},${HOME_ARR})
.PHONY: apply

sync: ### Synchronize configurations
	$(call synchronize_configuration_dir,${HOME}/.config,.config,${CONFIG_ARR})
	$(call synchronize_configuration_file,${HOME},${PWD},${HOME_ARR})
.PHONY: sync

help: ## Display this help screen
	@gawk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	${MAKEFILE_LIST}
.PHONY: help

