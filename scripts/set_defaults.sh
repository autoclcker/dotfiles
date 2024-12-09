#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

# Alacritty
alacritty=$(which alacritty)
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator "$alacritty" 50
sudo update-alternatives --set x-terminal-emulator "$alacritty"

# ZSH
git clone --depth https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

# Cheat
git clone --depth 1 https://github.com/cheat/cheatsheets.git "${XDG_CONFIG_HOME}/cheat/cheatsheets/community"

# Ueberzugpp
git clone --depth 1 https://github.com/jstkdng/ueberzugpp.git /tmp/ueberzugpp && "pushd $_" || exit 1
mkdir build && "pushd $_"
cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_TURBOBASE64=ON ..
cmake --build .
popd && sudo cmake --install build

# Tealder
tldr --update

# Fonts
if [[ ! -d /usr/local/share/fonts/nerd-fonts ]]; then
    sudo git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git /usr/local/share/fonts/nerd-fonts
    pushd "$_" || exit 1
    for a in Hack FiraCode DejaVuSansMono; do
        ./install.sh $a
    done
else
    printf "\e[1;96m%s\e[0m\n" "Fonts are already installed"
fi

exit 0
