#!/bin/bash

# Script to easily switch between manual and automatic exposure using v4l2-ctl
# 
# Logs activity to exposure.log 
#
# Usage:
#  Automatic exposure: 
#    set_exposure -a
# 
#  Manual exposure
#    set_exposure -m

CAMERA=/dev/video0
TIMESTAMP=$(date +%D-%H%M%S)

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


