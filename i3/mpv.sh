#!/bin/bash
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

pkill -f animatedWallpaper &
wait
pkill -f feh
feh --bg-fill "$SCRIPTPATH/black-background.jpg"
exec -a animatedWallpaper xwinwrap -fs -ni -s -ov -- mpv -wid WID --ytdl-format=mp4 $1
