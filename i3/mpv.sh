#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

pkill -f feh-slides.sh
pkill -f animatedWallpaper & wait

feh --bg-fill "$SCRIPTPATH/black-background.jpg"

exec -a animatedWallpaper xwinwrap -fs -ni -s -ov -- mpv -wid WID $1
