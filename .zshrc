export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.nimble/bin:$PATH
export ZSH="$HOME/.config/.oh-my-zsh"

# export ZSH_CUSTOM=$ZSH
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export EDITOR='nvim'

export TERM="alacritty"
export TERMINAL="alacritty"

export MANPAGER="nvim +Man!"

unsetopt BEEP # disable terminal beep
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

plugins=(git vi-mode history zsh-autosuggestions zsh-syntax-highlighting timer)

# ZSH_THEME="robbyrussell" # clean, current path
ZSH_THEME="nicoulaj" # clean, current full path
# ZSH_THEME="imajes" # simple
ENABLE_CORRECTION="true"
INSERT_MODE_INDICATOR="%F{blue}+%f"
TIMER_FORMAT='[%d]'
TIMER_PRECISION=2

source ~/.cody_auth.sh
source $ZSH/oh-my-zsh.sh
