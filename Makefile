all: help
.PHONY: all

apply: ### Apply configurations
	@cp -R .config/alacritty ~/.config | true
	@cp -R .config/wireshark ~/.config | true
	@cp -R .config/codium ~/.config | true
	@cp -R .config/tmux ~/.config | true
	@cp -R .config/nvim ~/.config | true
	@cp -R .config/htop ~/.config | true
	@cp -R .config/git ~/.config | true
	@cp -R .config/asdf/.tool-versions ~/ | true
	@cp -R .config/profile/.profile ~/ | true
	@cp -R .config/bash/.bashrc ~/ | true
	@cp -R .config/zsh/.zshrc ~/ | true
.PHONY: apply

sync: ### Synchronize configurations
	@cp -R ~/.config/wireshark/profiles .config/wireshark | true
	@cp -R ~/.config/alacritty .config | true
	@cp -R ~/.config/codium .config | true
	@cp -R ~/.config/tmux .config | true
	@cp -R ~/.config/nvim .config | true
	@cp -R ~/.config/htop .config | true
	@cp -R ~/.config/git .config | true
	@cp -R ~/.tool-versions .config/asdf | true
	@cp -R ~/.profile .config/profile | true
	@cp -R ~/.bashrc .config/bash | true
	@cp -R ~/.zshrc .config/zsh | true
.PHONY: sync

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' \
	${MAKEFILE_LIST}
.PHONY: help
