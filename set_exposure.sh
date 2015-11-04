#!/bin/bash

CAMERA=/dev/video0
TIMESTAMP=$(date +%D-%H%M%S)
TL=/usr/local/google/home/pkraker/timelapse

while [[ $# >0 ]]
do
key="$1"

case $key in
  -a|--auto)
  v4l2-ctl -d $CAMERA -c exposure_auto=3
  v4l2-ctl -d $CAMERA -c focus_auto=0
  v4l2-ctl -d $CAMERA -c focus_absolute=0
  echo "$TIMESTAMP  Setting exposure to Auto" >> $TL/exposure.log
  shift
  ;;
  -m|-manual)
  v4l2-ctl -d $CAMERA -c exposure_auto=1
  v4l2-ctl -d $CAMERA -c focus_auto=0
  v4l2-ctl -d $CAMERA -c focus_absolute=0
  echo "$TIMESTAMP  Setting exposure to Manual" >> $TL/exposure.log
  shift
  ;;
  *)

  ;;
esac
shift
done


