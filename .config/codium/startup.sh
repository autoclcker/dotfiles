#!/usr/bin/env bash

export PATH="$HOME/.local/share/mise/shims:$PATH"

java_path=$("${HOME}"/.local/bin/mise which java)
JAVA_HOME="$(dirname "$(dirname "${java_path:?}")")"
export JDK_HOME=${JAVA_HOME}

exec codium
