#!/bin/bash

#background="$HOME/.config/i3/screen_lock.png"

# Generate random gopher
$HOME/workspace/go/bin/drawmeagopher

gopher="/tmp/gopher.png"

# Fallback if image failed to download
if [ ! -s $gopher ]; then
    img="$HOME/.config/i3/screen_lock.png"
else
    img=$gopher
fi

scrot /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png

convert $img -resize 77.8% $img
if [[ -f $img ]]
then
    # placement x/y
    PX=0
    PY=0
    # lockscreen image info
    RX=$(convert $(readlink -f $img) -print "%w" /dev/null)
    RY=$(convert $(readlink -f $img) -print "%h" /dev/null)

    SR=$(xrandr --query | grep ' connected')
    IFS=$'\n'
    for RES in $SR
    do
        # monitor position/offset
        RES=$(echo $RES | sed 's/ primary//g')
        RES=$(echo $RES | cut -f3 -d' ')
        SRX=$(echo $RES | cut -d'x' -f 1)                   # x pos
        SRY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 1)  # y pos
        SROX=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 2) # x offset
        SROY=$(echo $RES | cut -d'x' -f 2 | cut -d'+' -f 3) # y offset
        PX=$(($SROX + $SRX/2 - $RX/2))
        PY=$(($SROY + $SRY/2 - $RY/2))

        convert /tmp/screen.png $img -geometry +$PX+$PY -composite -matte /tmp/screen.png
    done
fi

# lock
i3lock -e -f -n -i /tmp/screen.png 
