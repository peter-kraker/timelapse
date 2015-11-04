#!/bin/sh

# Script to take a picture every 30 seconds

TIME=`date +"%H%M%S"`
MONTH=`date +%m`
DAY=`date +%d`
TL=/usr/local/google/home/pkraker/timelapse

# Point CAMERA to which device you want to use
CAMERA=/dev/video0 


# Make a new photo director if there isn't one for today

if [ ! -d $TL/pics/$MONTH/$DAY ]; then
  mkdir -p $TL/pics/$MONTH/$DAY
fi


# Auto-exposure really sucks. Dump 60 frames of video to fix it.
# There has got to be a better way of ensuring auto-exposure does it's job

fswebcam -F 60 -d $CAMERA
sleep 3


# In order to get a better framerate, take a photo every 30 seconds.
# I really wish `at` or `cron` had second resolution

fswebcam -q -r 1920x1080 --no-banner -d $CAMERA \
  $TL/pics/$MONTH/$DAY/$TIME.jpg >> $TL/tl_info.log 2>&1

sleep 30

fswebcam -q -r 1920x1080 --no-banner -d $CAMERA \
  $TL/pics/$MONTH/$DAY/`date +"%H%M%S"`.jpg >> $TL/tl_info.log 2>&1
