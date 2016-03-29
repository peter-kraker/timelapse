#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`
TIME=120001 #`date +%H%M`
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
  -t|--time)
  TIME=$2
  ;;
  *)

  ;;
esac
shift
done

if [ ! -d $TL/times/$TIME ]; then
  mkdir -p $TL/times/$TIME
fi

# Get all the months in the folder, then each day.
for m in `find $TL/pics/ -type f -name $TIME.jpg` ; do
    d=`echo $m | cut -d"/" -f10`
    mon=`echo $m | cut -d"/" -f9`
    #echo " ln -s $m $TL/times/$TIME/$mon$d.jpg "; 
    ln -s $m $TL/times/$TIME/$mon$d.jpg
  done


