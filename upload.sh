#!/bin/bash
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
