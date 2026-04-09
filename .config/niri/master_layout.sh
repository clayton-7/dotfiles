#!/bin/bash

current_ws_id=""

# Parse niri msg windows output line by line
while IFS= read -r line; do
  if [[ "$line" =~ ^Window\ ID\ ([0-9]+):\ \(focused\) ]]; then
    # Found focused window ID
    focused_win_id="${BASH_REMATCH[1]}"
  fi

  if [[ "$line" =~ ^Window\ ID\ ([0-9]+): ]]; then
    current_win_id="${BASH_REMATCH[1]}"
  fi

  if [[ "$line" =~ ^\ +Workspace\ ID:\ ([0-9]+) ]]; then
    ws_id="${BASH_REMATCH[1]}"

    # If this window is focused, save its workspace ID
    if [[ "$current_win_id" == "$focused_win_id" ]]; then
      current_ws_id="$ws_id"
      break
    fi
  fi
done < <(niri msg windows)

if [[ -z "$current_ws_id" ]]; then
  exit 0
fi

# Collect windows only from current workspace
window_ids=()
current_win_id=""
while IFS= read -r line; do
  if [[ "$line" =~ ^Window\ ID\ ([0-9]+): ]]; then
    current_win_id="${BASH_REMATCH[1]}"
  fi

  if [[ "$line" =~ ^\ +Workspace\ ID:\ ([0-9]+) ]]; then
    ws_id="${BASH_REMATCH[1]}"
    if [[ "$ws_id" == "$current_ws_id" ]]; then
      window_ids+=("$current_win_id")
    fi
  fi
done < <(niri msg windows)

num_windows=${#window_ids[@]}

monitor_info=$(niri msg focused-output | grep -A5 'Output')

logical_size_line=$(echo "$monitor_info" | grep 'Logical size:')
screen_width=$(echo "$logical_size_line" | awk '{print $3}' | cut -d'x' -f1)
screen_height=$(echo "$logical_size_line" | awk '{print $3}' | cut -d'x' -f2)

master_width=$((screen_width / 2))
master_height=$screen_height
stack_width=$((screen_width / 2))
stack_height=$((screen_height / 2))

if [ "$num_windows" -eq 1 ]; then
  niri msg action set-window-width  --id "${window_ids[0]}" $screen_width
  niri msg action set-window-height --id "${window_ids[0]}" $screen_height

elif [ "$num_windows" -eq 2 ]; then
  niri msg action focus-column-last
  niri msg action consume-or-expel-window-right

  niri msg action set-window-width  --id "${window_ids[0]}" "$master_width"
  niri msg action set-window-height --id "${window_ids[0]}" "$master_height"

  niri msg action set-window-width  --id "${window_ids[1]}" "$master_width"
  niri msg action set-window-height --id "${window_ids[1]}" "$master_height"

  niri msg action focus-column-first
  niri msg action focus-column-last

elif [ "$num_windows" -eq 3 ]; then
  niri msg action focus-column-first

  niri msg action set-window-width  --id "${window_ids[0]}" "$master_width"
  niri msg action set-window-height --id "${window_ids[0]}" "$master_height"

  niri msg action set-window-width  --id "${window_ids[1]}" "$stack_width"
  niri msg action set-window-height --id "${window_ids[1]}" "$stack_height"

  niri msg action set-window-width  --id "${window_ids[2]}" "$stack_width"
  niri msg action set-window-height --id "${window_ids[2]}" "$stack_height"

  niri msg action focus-column-last
  niri msg action consume-or-expel-window-left
  # use one of the following:
  # this make the focus fixed in the current layout
  niri msg action focus-column-left
  niri msg action focus-column-left

  # this make the focus jumps to the last window
  # niri msg action focus-column-first
  # niri msg action focus-column-last
fi
