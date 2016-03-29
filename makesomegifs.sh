#  makesomegifs.sh
#
#    This script calls makeagif.sh in parallel over a sequence of dates. Default
#  behavior is to run through every day of the current month. Right now it's
#  dumb, and relies on errors down-stream to handle bad dates.
#
#  -m | --month - Single/Double digit month.
#    Default: Current Month 
#    
#  -f | --from - Date from which you want to start.
#    Default : 1
#
#  -t | --to - Date to which you want to end.
#    Default : 31
#
#  -o | --output - The output format of the videos you want to create.
#    Options : mkv | webm
#    Default : mkv

#!/bin/bash

MONTH=`date +%m`
FROM=1
TO=31
OUTPUT="mkv"

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
  -o|--output)
  OUTPUT=$2
  ;;
  *)

  ;;
esac
shift
done

# echo "Making videos from $FROM to $TO of Month $MONTH"
# Run in $TL directory, otherwise it's gonna break.

function makesomegifs() {
for i in `seq $FROM $TO`; do
  if [[ "$i" == [1-9] ]]; then
    echo "./makeagif.sh -m $MONTH -d 0$i -o $FORMAT"
  else
    echo "./makeagif.sh -m $MONTH -d $i -o $FORMAT"
  fi 
done
}

# Run two at a time

makesomegifs | xargs --max-procs=2 -n 1 -I CMD bash -c CMD
