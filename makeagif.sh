#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
DIR=/usr/local/google/home/pkraker/timelapse/pics

while [[ $# >1 ]]
do
key="$1"

case $key in 
  -m|--month)
  MONTH="$2"
  shift
  ;;
  -d|--day)
  DAY=$2
  shift
  ;;
  *)

  ;;
esac
shift
done

echo "DAY = $DAY"
echo "MONTH = $MONTH"

if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi 

mencoder mf://$DIR/$MONTH/$DAY/*.jpg -mf fps=25:type=jpg -ovc x264 -x264encopts bitrate=1200:threads=4 -o $DIR/$MONTH/$DAY-animated.mkv
