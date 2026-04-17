#!/usr/bin/env bash
read X Y W H <<< "$(slurp -f '%x %y %w %h')"

# shrink to remove 1px border
X=$((X+1)); Y=$((Y+1)); W=$((W-2)); H=$((H-2))

# capture selection into a temp file
tmp=$(mktemp --suffix=.png)
grim -g "${X},${Y} ${W}x${H}" "$tmp"

# create transparent canvas of same size and composite captured image over it (ensures transparency outside)
# Using ImageMagick (convert/composite). Output to stdout PNG and pipe to wl-copy.
convert -size "${W}x${H}" xc:transparent "$tmp" -composite png:- | wl-copy

rm -f "$tmp"
