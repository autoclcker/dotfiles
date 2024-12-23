alias ls='eza --color=always --icons=always'
alias lt='eza -T --color=always --icons=always'
alias ll='eza -lh --color=always --icons=always'
alias la='eza -a --color=always --icons=always'

eval "$(thefuck --alias)"

rga-fzf() {
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "$1" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
	xdg-open "$file"
}

