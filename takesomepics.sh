#!/bin/sh

# Script to take a picture every 30 seconds. Also responsible for creating the
#   directory structure that pictures are kept in.
#

TIME=`date +"%H%M%S"`
MONTH=`date +%m`
DAY=`date +%d`

# Point CAMERA to which device you want to use
CAMERA=/dev/video0 


# Make a new photo directory if there isn't one for today

if [ ! -d $TL/pics/$MONTH/$DAY ]; then
  mkdir -p $TL/pics/$MONTH/$DAY
fi


# Auto-exposure on webcams really sucks. Dump 60 frames of video to force the 
#   camera to do it's job. 
# 
# Doing this every 5 minutes to try and reduce flicker from changing the 
#   exposure every other frame
#
# There has got to be a better way of ensuring auto-exposure does it's job

if [ `date +%M` % 5 == 0 ]; then
  fswebcam -F 60 -d $CAMERA
  sleep 5
fi

# In order to get a better framerate on the final video, take a photo every 30
#   seconds.
#
# I really wish `at` or `cron` had second resolution. I hate using `sleep`

fswebcam -q -r 1920x1080 --no-banner -d $CAMERA \
  $TL/pics/$MONTH/$DAY/$TIME.jpg >> $TL/tl_info.log 2>&1

sleep 30

fswebcam -q -r 1920x1080 --no-banner -d $CAMERA \
  $TL/pics/$MONTH/$DAY/`date +"%H%M%S"`.jpg >> $TL/tl_info.log 2>&1
