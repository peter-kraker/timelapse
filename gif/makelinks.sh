#!/bin/bash

MONTH=`date +%m`
DAY=`date +%d`

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
  *)

  ;;
esac
shift
done

# Returns the average (Brightness...?) of the image
#   There isn't really any documentation on what the %[mean] feature
#   of identify does...

get_average () {
  AVRG=`identify -format "%[mean]" $1`
  INTAVRG=`printf "%.0f\n" $AVRG`
  echo $INTAVRG
}

a=1

# Counter for the number of frames that are too bright, i.e. flashes
too_bright=0

for i in $TL/pics/$MONTH/$DAY/*.jpg; do
  MEAN=`get_average $i`

# If the mean brightness is higher than the threshold, dump the frame.
# Threshold Values:
# * 45000 - Excludes most of the day
# * 55000 - Cuts out
# * 65000 - Lose an average of ~15 frames.

  if [ $MEAN -lt 1000000 ];
    then
      new=$(printf "%04d.JPG" ${a}) #04 pad to length of 4
      ln -s ${i} $TL/gif/${new}
      let a=a+1
    else
      echo $i $MEAN
      ((too_bright++))
  fi

done
FRAMES=$(ls -l $TL/pics/$MONTH/$DAY | wc) 
echo "Made links for $FRAMES frames"
echo $too_bright frames were too bright.

