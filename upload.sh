#!/bin/bash

# Script to upload a movie cerated by makeagif.sh to YouTube.
# requires the upload_video.py script created by Google; can be found:
#
# https://developers.google.com/youtube/v3/guides/uploading_a_video
# 

MONTH=`date +%m`
DAY=`date +%d`
YEAR=`date +%Y`
FORMAT="mkv"
DRYRUN=0

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
  --dryrun)
  DRYRUN=$2
  ;;
  *)

  ;;
esac
shift
done

echo "RUNNING upload.sh -m $MONTH -d $DAY" >> $TL/tl_info.log
echo "$TL/pics/$MONTH/$DAY-animated.$FORMAT" >> $TL/tl_info.log

if [[ $DRYRUN -eq 1 ]] ; then 
  python $TL/upload_video.py --file 
fi

python $TL/upload_video.py --file $TL/pics/$MONTH/$DAY-animated.$FORMAT \
                       --title "Olympic Timelapse $MONTH $DAY, $YEAR" \
                       --privacyStatus "public"
