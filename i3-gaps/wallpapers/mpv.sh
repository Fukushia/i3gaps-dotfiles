#!/bin/bash
pkill -f animatedWallpaper &
wait
exec -a animatedWallpaper xwinwrap -fs -ni -s -ov -- mpv -wid WID $1
