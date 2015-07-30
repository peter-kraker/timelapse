#!/bin/sh

TIME=`date +"%H%M"`
MONTH=`date +%m`
DAY=`date +%d`
TL=/usr/local/google/home/pkraker/timelapse

if [ ! -d $TL/pics/$MONTH/$DAY ]; then
  mkdir -p $TL/pics/$MONTH/$DAY
fi

fswebcam -q -r 1900x1080 --no-banner -d /dev/video1 $TL/pics/$MONTH/$DAY/$TIME.jpg >> $TL/tl_info.log 2>&1
