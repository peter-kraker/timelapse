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
#
#   -e - Encoder to use (ffmpeg, avconv)
#     Default: avconv 

#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
FRAMERATE=60
OUTPUT='mkv'
ENCODER='avconv'

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
  shift
  ;;
  -e|--encoder)
  ENCODER=$2
  shift
  ;;
  -o|--output)
  OUTPUT=$2
  ;;
  *)

  ;;
esac
shift
done

echo "mencoder 
        -msglevel mencoder=-1 
        -msgcolor  
        mf://$TL/pics/$MONTH/$DAY/*.jpg 
        -fm fps=$FRAMERATE:type=jpg 
        -ovc x264 
        -x264encopts bitrate=1200:threads=3 
        -o $TL/pics/$MONTH/$DAY-animated.$OUTPUT" >> /dev/null

if [[ -n $1 ]]; then
  echo "Last line of file specified as non-opt/last argument:"
  tail -1 $1
fi 

case $ENCODER in
  "avconv")
   avconv -framerate 25 -f image2 -i $TL/gif/%04d.JPG -c:v h264 -crf 1 $TL/pics/$MONTH/$DAY-animated.mkv
  ;;
  *)
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
  ;;
esac
