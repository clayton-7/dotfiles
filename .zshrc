export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'

export TERM="alacritty"
export TERMINAL="alacritty"

export MANPAGER="nvim +Man!"

set -o ignoreeof

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
ENABLE_CORRECTION="true"
INSERT_MODE_INDICATOR="%F{blue}+%f"
TIMER_FORMAT='[%d]'
TIMER_PRECISION=2
setopt appendhistory

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit && compinit
zmodload -i zsh/complist

# colors
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

## case insensitive path-completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

autoload -Uz compinit
compinit

# up and down completes the current command using history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"

unsetopt BEEP # disable terminal beep

# source ~/.config/.zsh/nicoulaj.zsh-theme
source ~/.config/.zsh/common.zsh-theme
source ~/.config/.zsh/config.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/.zsh/vi-mode.zsh
source ~/.config/.zsh/timer.zsh
source ~/.config/.zsh/zsh-history-substring-search.zsh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
