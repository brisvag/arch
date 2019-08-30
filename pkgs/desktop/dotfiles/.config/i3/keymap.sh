#!/bin/bash

LG=$(setxkbmap -query | awk '/layout/{print $2}')
LG=${LG^^}
if [ $LG == "US" ]
then
    echo "<span color='#009E00'>$LG</span>"
else
    echo "<span color='#C60101'>$LG</span>"
fi

