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
#
#   -o - Output format of the resulting video
#     Default : mkv

#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
FRAMERATE=60
OUTPUT='mkv'

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
  -o|--output)
  OUTPUT=$2
  ;;
  *)

  ;;
esac
shift
done

echo $TL
echo "DAY = $DAY"
echo "MONTH = $MONTH"
echo "mencoder 
        -msglevel mencoder=-1 
        -msgcolor  
        mf://$TL/pics/$MONTH/$DAY/*.jpg 
        -fm fps=$FRAMERATE:type=jpg 
        -ovc x264 
        -x264encopts bitrate=1200:threads=3 
        -o $TL/pics/$MONTH/$DAY-animated.$OUTPUT"

if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi 

# Currently using three threads for encoding.

case $OUTPUT in 
  "mkv")
    mencoder mf://$TL/pics/$MONTH/$DAY/*.jpg -mf fps=$FRAMERATE:type=jpg \
      -msglevel mencoder=-1 \
      -msgcolor \
      -ovc x264 \
      -x264encopts bitrate=1200:threads=3 \
      -o $TL/pics/$MONTH/$DAY-animated.mkv
  ;;
  "webm")
    # Trying different encoding options for video format / quality.
    mencoder mf://$TL/pics/$MONTH/$DAY/*.jpg \
      -msgcolor \
      -mf fps=$FRAMERATE:type=jpg \
      -ovc lavc \
      -of lavf \
      -lavfopts format=webm \
      -lavcopts threads=3:vcodec=libvpx \
      -o $TL/pics/$MONTH/$DAY-animated.webm
  ;;
  *)
    echo "Video Format not recognized. Cannot encode video" >> $TL/tl_info.log
  ;;
esac
