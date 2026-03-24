export ZSH="@OH_MY_ZSH@"
ZSH_THEME="ys"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"
source @ZSH_AUTOSUGGESTIONS@
source @ZSH_SYNTAX_HIGHLIGHTING@
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
alias cd=z
vis() { nvim $(fzf --query="$1" --preview 'bat --style=numbers --color=always {}') }
