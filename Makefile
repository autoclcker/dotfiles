all: help
.PHONY: all

CONFIG_CLI_ARR = btop cheat dive k9s lazydocker lazygit mise nvim procps procs wireshark/profiles yazi
CONFIG_UI_ARR = copyq ghostty mimeapps.list pop-shell tmux
DESKTOP_ARR = neovide.desktop
HOME_ARR   = .bash_aliases .bashrc .gitconfig .profile .vimrc .vscodevimrc .zlogin .zshrc

DESKTOP_APPLICATIONS_HOME = ${HOME}/.local/share/applications
XDG_CONFIG_HOME = ${HOME}/.config
ZSH_HOME = ${HOME}/.oh-my-zsh

SHORT_COMMIT=$(shell git rev-parse --short HEAD)

docker%: export GITHUB_TOKEN ?= "STUB"

docker/build-debug:
	@docker buildx build --quiet --tag debug-${SHORT_COMMIT} --target debug --file Dockerfile.regress .
.PHONY: docker/build-debug

docker/debug: docker/build-debug ### Debug in Docker
	@docker run --rm --interactive --tty --env GITHUB_TOKEN=${GITHUB_TOKEN} debug-${SHORT_COMMIT}
.PHONY: docker/debug

docker/regress: ### Validate Setup integrity
	@docker buildx build --secret id=GITHUB_TOKEN --tag regress --file Dockerfile.regress .
	@docker rmi regress:latest
.PHONY: docker/regress

download:
	@./scripts/download_core_apps.sh --packages $(shell cat ${PWD}/deps/*)
.PHONY: download

git/stage: ### Stage configurations
	@git add  */.*
.PHONY: git/stage

install: download sync ### Install setup
	@./scripts/set_defaults.sh
.PHONY: install

sync: ### Synchronize configurations
	@./scripts/synchronize_configuration.sh --searchpath ${PWD} --destination ${HOME} ${HOME_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_CLI_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.config --destination ${XDG_CONFIG_HOME} ${CONFIG_UI_ARR}
	@./scripts/synchronize_configuration.sh --searchpath ${PWD}/.desktop --destination ${DESKTOP_APPLICATIONS_HOME} ${DESKTOP_ARR}
	@./scripts/install_tools.sh
.PHONY: sync

upgrade: ### Upgrade setup
	@${ZSH_HOME}/tools/upgrade.sh
	@yes | mise self-update
	@mise upgrade
	@nvim --headless "+Lazy! sync" +qa
	@tldr --update
	@ya pkg upgrade
.PHONY: upgrade

help: ## Display this help screen
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} \
	/^[/a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
	/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) }' \
	${MAKEFILE_LIST}
.PHONY: help
