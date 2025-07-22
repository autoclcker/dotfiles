alias grep='rg'
alias la='eza --all --color=always --icons=always'
alias ll='eza --long --group --git --header --color=always --icons=always'
alias lR='eza --tree --color=always --icons=always'
alias ls='eza --color=always --icons=always'

eval "$(thefuck --alias)"

eval "$(delta --generate-completion zsh)"
