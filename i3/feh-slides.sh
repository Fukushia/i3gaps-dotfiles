#!/bin/bash

if ps -Al | grep animatedWallpaper; then
  pkill -f animatedWallpaper &
  wait
fi

while true; do 
  feh --recursive --randomize --bg-fill ~/wallpapers/images
  sleep 5
done
