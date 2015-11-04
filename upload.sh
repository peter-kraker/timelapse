#!/bin/bash

# Script to upload a movie cerated by makeagif.sh to YouTube.
# requires the upload_video.py script created by Google; can be found:
#
# https://developers.google.com/youtube/v3/guides/uploading_a_video
# 

TL=/usr/local/google/home/pkraker/timelapse
MONTH=`date +%m`
DAY=`date +%d`

while [[ $# >1 ]]
do
key="$1"

case $key in
  -m|--month)
  MONTH=$2
  shift
  ;;
  -d|--day)
  DAY=$2
  shift
  ;;
  -f|--framerate)
  FRAMERATE=$2
  ;;
  *)

  ;;
esac
shift
done

python upload_video.py --file $TL/pics/$MONTH/$DAY-animated.mkv --title "Tokyo Timelapse $MONTH $DAY" --privacyStatus "unlisted"
