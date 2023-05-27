#!/usr/bin/fish

if status is-interactive
    # Commands to run in interactive sessions can go here
end

theme_gruvbox dark medium

xrandr --output DP-0 --primary --dpi 132 --output HDMI-0 --right-of DP-0 --rotate right --dpi 96
alias ls='exa -la --color=always --group-directories-first'
xset r rate 250 100
bass source ~/dev/vulkan/1.3.239.0/setup-env.sh
