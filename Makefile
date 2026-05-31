all: help
.PHONY: all

DE ?= ${PWD}/scripts/installation/driver.sh
WRAPPERS ?= ${PWD}/scripts/wrappers

CONFIG_CLI_APPS := cheat mise mimeapps.list
CONFIG_GUI_APPS := autostart copyq cosmic ghostty wireshark
CONFIG_TUI_APPS := bookokrat btop dive k9s lazydocker lazygit nvim procps tmux yazi

BIN_ARR     = $(shell ls ${WRAPPERS})
CONFIG_ARR  = $(CONFIG_CLI_APPS) $(CONFIG_GUI_APPS) $(CONFIG_TUI_APPS)
DESKTOP_ARR = $(shell ls ${PWD}/.desktop)
HOME_ARR    = .bashrc .gitconfig .profile .vimrc .vscodevimrc .zshrc

BIN_HOME          ?= ${HOME}/.local/bin
DESKTOP_APPS_HOME ?= ${HOME}/.local/share/applications
OH_MY_ZSH_HOME    ?= ${HOME}/.oh-my-zsh
XDG_CONFIG_HOME   ?= ${HOME}/.config

BRANCH ?= $(shell git branch --show-current)
SHELL := /bin/bash
SHORT_COMMIT ?= $(shell git rev-parse --short HEAD)

# TODO: implement
# ansible/install: docker/build-ansible ### Install setup on the target host
# 	@docker run --rm ${BRANCH}/ansible:${SHORT_COMMIT}
# .PHONY: ansible/install

# ansible/dry-run: ansible-lint ### Validate Setup integrity
# 	@docker run --rm ${BRANCH}/ansible:${SHORT_COMMIT}
# .PHONY: ansible/dry-run

# ansible/lint:
# .PRONE: ansible/lint

docker%: export GITHUB_TOKEN ?= "STUB"

docker/build-ansible:
	@docker buildx build --quiet --tag ${BRANCH}/ansible:${SHORT_COMMIT} --file Dockerfile.ansible .
.PHONY: docker/build-ansible

docker/build-debug:
	@docker buildx build --quiet --tag ${BRANCH}/debug:${SHORT_COMMIT} --target debug --file Dockerfile.smoke .
.PHONY: docker/build-debug

docker/debug: docker/build-debug ### Debug in Docker
	@docker run --rm --interactive --tty --env GITHUB_TOKEN=${GITHUB_TOKEN} ${BRANCH}/debug:${SHORT_COMMIT}
.PHONY: docker/debug

docker/bvt: ### Build Verification Test
	@docker buildx build --secret id=GITHUB_TOKEN --tag ${BRANCH}/smoke --file Dockerfile.smoke .
	@docker rmi ${BRANCH}/smoke:latest
.PHONY: docker/bvt

download:
	@${DE} download_core_apps --packages $(shell cat ${PWD}/deps/buildtime.txt)
.PHONY: download

install: download sync ### Install setup
	@${DE} install_desktop
	@${DE} install_tools --packages $(shell cat ${PWD}/deps/tools.txt)
	@${DE} set_defaults
.PHONY: install

sync: ### Synchronize configurations
	@${DE} synchronize_configuration --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@${DE} synchronize_configuration --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_ARR}
	@${DE} synchronize_configuration --searchpath ${PWD}/.desktop --destination ${DESKTOP_APPS_HOME} ${DESKTOP_ARR}
	@${DE} synchronize_configuration --searchpath ${WRAPPERS} --destination ${BIN_HOME} ${BIN_ARR}
.PHONY: sync

upgrade: ### Upgrade setup
	@${OH_MY_ZSH_HOME}/tools/upgrade.sh
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
