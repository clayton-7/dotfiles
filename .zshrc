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
setopt appendhistory

fpath=(/usr/local/share/zsh-completions $fpath)
autoload -U compinit && compinit
zmodload -i zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

unsetopt BEEP # disable terminal beep

# source ~/.config/.zsh/nicoulaj.zsh-theme
source ~/.config/.zsh/common.zsh-theme
source ~/.config/.zsh/config.zsh
source ~/.config/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/.zsh/vi-mode.zsh
source ~/.config/.zsh/timer.zsh
source ~/.config/.zsh/zsh-history-substring-search.plugin.zsh
source ~/.config/.zsh/zsh-history-substring-search.zsh

source ~/.cody_auth.sh
source ~/dev/vulkan_1.3.283.0/setup-env.sh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
