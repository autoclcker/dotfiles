all: help
.PHONY: all

CONFIG_CLI_APPS := cheat mise mimeapps.list
CONFIG_GUI_APPS := autostart copyq cosmic ghostty wireshark
CONFIG_TUI_APPS := btop dive k9s lazydocker lazygit nvim procps tmux yazi

CONFIG_ARR  = $(CONFIG_CLI_APPS) $(CONFIG_GUI_APPS) $(CONFIG_TUI_APPS)
DESKTOP_ARR = $(shell ls ${PWD}/.desktop)
HOME_ARR    = .bashrc .gitconfig .profile .vimrc .vscodevimrc .zshrc

DESKTOP_APPS_HOME ?= ${HOME}/.local/share/applications
XDG_CONFIG_HOME   ?= ${HOME}/.config
ZSH_HOME          ?= ${HOME}/.oh-my-zsh

BRANCH ?= $(shell git branch --show-current)
SHORT_COMMIT ?= $(shell git rev-parse --short HEAD)

docker%: export GITHUB_TOKEN ?= "STUB"

docker/build-debug:
	@docker buildx build --quiet --tag ${BRANCH}/debug:${SHORT_COMMIT} --target debug --file Dockerfile.regress .
.PHONY: docker/build-debug

docker/debug: docker/build-debug ### Debug in Docker
	@docker run --rm --interactive --tty --env GITHUB_TOKEN=${GITHUB_TOKEN} ${BRANCH}/debug:${SHORT_COMMIT}
.PHONY: docker/debug

docker/regress: ### Validate Setup integrity
	@docker buildx build --secret id=GITHUB_TOKEN --tag ${BRANCH}/regress --file Dockerfile.regress .
	@docker rmi ${BRANCH}/regress:latest
.PHONY: docker/regress

download:
	@./scripts/download_core_apps.sh --packages $(shell cat ${PWD}/deps/*)
	@./scripts/install_desktop.sh
.PHONY: download

install: download sync ### Install setup
	@./scripts/set_defaults.sh
.PHONY: install

sync: ### Synchronize configurations
	@./scripts/synchronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.desktop --destination ${DESKTOP_APPS_HOME} ${DESKTOP_ARR}
	@./scripts/install_tools.sh
.PHONY: sync

upgrade: ### Upgrade setup
	@${ZSH_HOME}/tools/upgrade.sh
	@yes | mise self-update
	@mise upgrade
	@tldr --update
	@nvim --headless "+Lazy! sync" +qa
	@ya pkg upgrade
	@yay
.PHONY: upgrade

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
	${MAKEFILE_LIST}
.PHONY: help
