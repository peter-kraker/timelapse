#!/bin/bash

START=1
END=31
FORMAT="mkv"
MONTH=`date +%m`

while [[ $# >1 ]]
do
key="$1"

case $key in
  -m|--month)
  if [[ "$2" == [1-9] ]]; then
    MONTH=0$2
  else
    MONTH=$2
  fi
  shift
  -f|--format)
  FORMAT=$2
  shift
  ;;
  -s|--start)
  START=$2
  shift
  ;;
  -e|--end)
  END=$2
  ;;
  *)

  ;;
esac
shift
done

for i in `seq $START $END`; do
  ./upload.sh -m $MONTH -d $i -f $FORMAT 
done
