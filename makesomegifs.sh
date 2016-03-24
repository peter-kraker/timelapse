#!/bin/bash

FROM=1
TO=31

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
  ;;
  -t|--to)
  TO=$2
  shift
  ;;
  -f|--from)
  FROM=$2
  ;;
  *)

  ;;
esac
shift
done

# echo "Making videos from $FROM to $TO of Month $MONTH"

function makesomegifs() {
for i in `seq $FROM $TO`; do
  if [[ "$i" == [1-9] ]]; then
    echo "./makeagif.sh -m $MONTH -d 0$i"
    #./upload.sh -m $MONTH -d 0$i 
  else
    echo "./makeagif.sh -m $MONTH -d $i"
  fi 
done
}

makesomegifs | xargs --max-procs=2 -n 1 -I CMD bash -c CMD
