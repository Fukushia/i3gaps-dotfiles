#!/bin/bash
SCRIPT=$(readlink -f "$0")

pkill -f animatedWallpaper & wait

if [[ `ps -Al | grep -c feh-slides.sh` -gt 2 ]]; then
  exit
fi

feh --recursive --randomize --bg-fill ~/wallpapers/images
sleep 5
exec "$SCRIPT"


