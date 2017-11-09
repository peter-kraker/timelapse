#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
YEAR=`date +%Y`
FORMAT="mkv"

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

echo "`date` :: -----BEGIN doitall.sh-----" >> $TL/tl_info.log

# Make the links
echo "`date` :: -----STARTING makelinks.sh -d $DAY -m $MONTH" >> $TL/tl_info.log
$TL/gif/makelinks.sh -d $DAY -m $MONTH >> $TL/tl_info.log 2>&1
echo "`date` :: -----DONE makelinks.sh" >> $TL/tl_info.log

# Make the gif
echo "`date` :: -----STARTING makeagif.sh -m $MONTH -d $DAY" >> $TL/tl_info.log
$TL/makeagif.sh -m $MONTH -d $DAY >> $TL/tl_info.log 2>&1
echo "`date` :: -----DONE makeagif.sh" >> $TL/tl_info.log

#Upload the video
echo "`date` :: -----STARTING upload.sh -m $MONTH -d $DAY" >> $TL/tl_info.log
$TL/upload.sh -m $MONTH -d $DAY >> $TL/tl_info.log 2>&1
echo "`date` :: -----DONE upload.sh" >> $TL/tl_info.log

#Clean up
echo "`date` :: -----STARTING clean.sh" >> $TL/tl_info.log
$TL/gif/clean.sh >> $TL/tl_info.log 2>&1
echo "`date` :: -----DONE clean.sh" >> $TL/tl_info.log

echo "`date` :: -----END-----" >> $TL/tl_info.log
