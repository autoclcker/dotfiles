all: help
.PHONY: all

-include .ansible/Makefile

DE ?= ${PWD}/scripts/installation/driver.sh
WRAPPERS ?= ${PWD}/scripts/wrappers

REMOTE_INSTALL_ENVS := ANSIBLE_HOST ANSIBLE_USER ANSIBLE_PASSWORD GITHUB_TOKEN

CONFIG_CLI_APPS := cheat mise mimeapps.list systemd
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
REV ?= $(shell git rev-parse --short HEAD)
SHELL := /bin/bash

ansible/check-env-vars:
	@for var in $(REMOTE_INSTALL_ENVS); do \
		if [ -z "$${!var}" ]; then \
			printf "=================================================================\n"; \
			printf "❌ ERROR: Environment variable %s is not set.\n" "$$var"; \
			printf "💡 Help: You can provide it via your shell:\n\n"; \
			printf "export %s=%%%%YOUR_%s%%%%\n\n" "$$var" "$$var"; \
			printf "=================================================================\n"; \
			printf "ℹ️  Note: you must define all of the following variables:\n"; \
			printf "• %s\n" $(REMOTE_INSTALL_ENVS); \
			printf "=================================================================\n"; \
			exit 1; \
		fi; \
	done
.PHONY: ansible/check-env-vars

ansible/dry-run: docker/build-molecule ### Validate Setup integrity
	@docker run --rm --env GITHUB_TOKEN=${GITHUB_TOKEN} \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		${BRANCH}/molecule:${REV}
.PHONY: ansible/dry-run

ansible/install: ansible/check-env-vars docker/build-ansible ### Install setup on the target host
	@docker run --rm --network=host --interactive --tty --env GITHUB_TOKEN=${GITHUB_TOKEN} \
		${BRANCH}/ansible:${REV} ansible-playbook \
			--extra-vars "ansible_host=${ANSIBLE_HOST}" \
			--extra-vars "ansible_user=${ANSIBLE_USER}" \
			--extra-vars "ansible_password=${ANSIBLE_PASSWORD}" \
			.ansible/playbook.yml
.PHONY: ansible/install

ansible/lint: ### Static analysis of Ansible manifests
	@docker buildx build --tag ${BRANCH}/ansible-lint:${REV} --target lint --file Dockerfile.ansible .
.PHONY: ansible/lint

docker%: export GITHUB_TOKEN ?= "STUB"

docker/build-ansible: ansible/lint
	@docker buildx build --quiet --tag ${BRANCH}/ansible:${REV} --file Dockerfile.ansible .
.PHONY: docker/build-ansible

docker/build-debug:
	@docker buildx build --quiet --tag ${BRANCH}/debug:${REV} --target debug --file Dockerfile.smoke .
.PHONY: docker/build-debug

docker/build-molecule: ansible/lint
	@docker buildx build --tag ${BRANCH}/molecule:${REV} --target dry-run --file Dockerfile.ansible .
.PHONY: docker/build-molecule

docker/debug: docker/build-debug ### Debug in Docker
	@docker run --rm --interactive --tty --env GITHUB_TOKEN=${GITHUB_TOKEN} ${BRANCH}/debug:${REV}
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
	@${DE} install_tools --packages $(shell cat ${PWD}/deps/common/*)
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
