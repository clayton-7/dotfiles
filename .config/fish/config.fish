#!/usr/bin/fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# theme_gruvbox dark medium

# xrandr --output DP-0 --primary --dpi 132 --output HDMI-0 --right-of DP-0 --dpi 96 --rotate right
alias ls='exa --color=always --group-directories-first'
alias e='cd $(exa -a | fzf --reverse) && ll'
xset r rate 250 100
bass source ~/dev/vulkan/1.3.239.0/setup-env.sh
set PATH "$HOME/.cargo/bin:$PATH"
export LD_LIBRARY_PATH=/home/clayton/dev/webgpu:$LD_LIBRARY_PATH
