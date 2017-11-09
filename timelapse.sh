#!/bin/bash

# Script that schedules photos to be taken between before sunrise (twirise)
#   and twilight (after sunset). 
#

if [[ -z `cat $TL/sunrise` || -z `cat $TL/sunset` ]]; then
  echo "SUNRISE / SUNSET isn't set -- Won't take pictures" >> $TL/tl_info.log
  exit -1 
fi

# All dates are expressed as seconds from epoch
SUNRISE=$(date -d $(cat $TL/sunrise) +%s)
SUNSET=$(date -d $(cat $TL/sunset) +%s)
NOW=$(date +%s)

# Before and after functions:
# 
#   $1: The time you want to modify (e.g. now)
#   $2: The amount of time you want change $1 by
#   
#   Ten minutes (600 seconds) from now would be:
#
#       before `date +%s` 600  
#

function before {
  echo $(($1 - $2))
}

function after {
  echo $(($1 + $2))
}


# Returns one minute from now in Hour:Minute format (e.g. 18:50)
function oneminlater {
  date -d "@$(($(date +%s) + 60))" +%H:%M
}

TWIRISE=$(before $SUNRISE 6000) # 100 mintues before sunrise
TWILIGHT=$(after $SUNSET 5400) # 90 minutes after sunset

if [ $NOW -gt $TWIRISE ] && [ $NOW -lt $TWILIGHT ];
  then
    echo "taking pics @ `oneminlater`" >> $TL/tl_info.log
    at -f $TL/takesomepics.sh `oneminlater` 2>> $TL/tl_info.log
  else
    echo "I will take pictures at $(date -d @$(($TWIRISE)) +%H:%M)" 
fi
