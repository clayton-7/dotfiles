#!/bin/bash
[ -n "$1" ] && file=$1
[ -n "$2" ] && line=$2
# nvim --server ~/.cache/nvim/defold.pipe --remote-send ':e +'$line' '$file'<CR>'

term="alacritty"
nvim="nvim"
filepath=$(echo "$file" | sed 's:/*$::')
server_path="$HOME/.cache/nvim/game_engine.pipe"

start_server() {
    "$term" -e "$nvim" --listen "$server_path" "$file"
}

open_file() {
    # "$term" nvim --server "$server_path" --remote-send "<C-\><C-n>:n $1<CR>:call cursor($2)<CR>"
    # "$term" "$nvim" --server "$server_path" --remote-send ':e +'$line' '$file'<CR>'
    # "$term" -e "$nvim" --server "$server_path" --remote-send ':e +'$line' '$file'<CR>'

    if [ -z "$line" ]; then
        nvim --server "$server_path" --remote-send '<Esc>:e '$file'<CR>'
    else
        nvim --server "$server_path" --remote-send '<Esc>:e +'$line' '$file'<CR>'
    fi
}

if ! [ -e "$server_path" ]; then
    start_server "$1"
else
    open_file "$1" "$2"
fi
