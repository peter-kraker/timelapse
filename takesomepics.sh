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
  mkdir -p -v "$TL/pics/$MONTH/$DAY"
fi


# Set Focus to 0, farthest away. Disable the flourecent light compensation.
# fswebcam -s "Focus, Auto"="False"
# fswebcam -s "Focus (absolute)"=0 -s "Power Line Frequency"="Disabled" 2>&1
# fswebcam -s "Exposure, Auto Priority"="False"
# v4l2-ctl --set-ctrl=exposure_auto_priority=0


# Auto-exposure on webcams really sucks. Dump 15 frames of video to force the 
#   camera to do it's job. 
# 
# Doing this before every fram to reduce flicker from changing the 
#   exposure every other frame
#
# There has got to be a better way of ensuring auto-exposure does it's job
#
# The -S flag for fswebcam dumps N frames, maybe we don't need this step.

fswebcam -q -r 1280x720 -D 5 -S 60 --no-banner -d $CAMERA \
  -s "Focus, Auto"="False" -s "Focus (absolute)"=0 \
  -s "Power Line Frequency"="Disabled" \
  -s "Exposure, Auto Priority"="True" \
  $TL/pics/$MONTH/$DAY/$TIME.jpg >> $TL/tl_info.log 2>&1

# In order to get a better framerate on the final video, take a photo every 30
#   seconds.
#
# I really wish `at` or `cron` had second resolution. I hate using `sleep`

sleep 30 


# Reset $TIME for the second photo
TIME=`date +"%H%M%S"`


# Now do it again
fswebcam -q -r 1280x720 -D 5 -S 60 --no-banner -d $CAMERA \
  -s "Focus, Auto"="False" -s "Focus (absolute)"=0 \
  -s "Power Line Frequency"="Disabled" \
  -s "Exposure, Auto Priority"="True" \
  $TL/pics/$MONTH/$DAY/$TIME.jpg >> $TL/tl_info.log 2>&1
