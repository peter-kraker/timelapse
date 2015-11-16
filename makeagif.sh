# makeagif.sh -- takes a folder of jpegs and turns it into a mkv
# requires mencode
#
# Usage:
#
#   -m - Two-digit Month (i.e. Jan = 01)
#     Default : the current month
#
#   -d - Two-digit Day (i.e. 3rd = 03)
#     Default : the current day
#
#   -f - Framerate of the resulting video
#     Default : 60

#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
FRAMERATE=60

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

echo "DAY = $DAY"
echo "MONTH = $MONTH"
echo "mencoder mf://$TL/pics/$MONTH/$DAY/*.jpg \
        -fm fps=$FRAMERATE:type=jpg \
        -ovc x264 \
        -x264encopts bitrate=1200:threads=4 \
        -o $TL/pics/$MONTH/$DAY-animated.mkv"

if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi 

mencoder mf://$TL/pics/$MONTH/$DAY/*.jpg -mf fps=$FRAMERATE:type=jpg \
  -ovc x264 \
  -x264encopts bitrate=1200:threads=4 \
  -o $TL/pics/$MONTH/$DAY-animated.mkv

# Trying different encoding options for video format / quality.

mencoder mf://$TL/pics/$MONTH/$DAY/*.jpg \
  -mf fps=$FRAMERATE:type=jpg \
  -ovc lavc \
  -of lavf \
  -lavfopts format=webm \
  -lavcopts threads=4:vcodec=libvpx \
  -o $TL/pics/$MONTH/$DAY-animated.webm
