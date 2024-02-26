all: help
.PHONY: all

sync: ### Synchronize configurations
	@cp -R ~/.config/alacritty/alacritty.yml .config/alacritty | true
	@cp -R ~/.config/wireshark/profiles .config/wireshark | true
	@cp -R ~/.config/codium .config/codium | true
	@cp -R ~/.config/tmux .config/tmux | true
	@cp -R ~/.config/nvim .config/nvim | true
	@cp -R ~/.config/htop .config/htop | true
	@cp -R ~/.config/git .config/git | true
	@cp -R ~/.tool-versions .config/asdf | true
	@cp -R ~/.profile .config/profile | true
	@cp -R ~/.bashrc .config/bash | true
	@cp -R ~/.zshrc .config/zsh | true
.PHONY: build

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	${MAKEFILE_LIST}
.PHONY: help
