#!/bin/bash

# Script to upload a movie cerated by makeagif.sh to YouTube.
# requires the upload_video.py script created by Google; can be found:
#
# https://developers.google.com/youtube/v3/guides/uploading_a_video
# 

MONTH=`date +%m`
DAY=`date +%d`
FORMAT="webm"

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
  -f|--format)
  FORMAT=$2
  ;;
  *)

  ;;
esac
shift
done

echo "$TL/pics/$MONTH/$DAY-animated.$FORMAT"

python $TL/upload_video.py --file $TL/pics/$MONTH/$DAY-animated.$FORMAT \
                       --title "Tokyo Timelapse $MONTH $DAY" \
                       --privacyStatus "unlisted" >> $TL/tl_info.log
