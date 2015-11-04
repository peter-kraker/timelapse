#!/bin/bash

# Script that schedules photos to be taken between before sunrise (twirise)
# and twilight (after sunset). 

TL=/usr/local/google/home/pkraker/timelapse

# Dates are expressed as seconds from epoch
SUNRISE=$(date -d $(cat $TL/sunrise) +%s)
SUNSET=$(date -d $(cat $TL/sunset) +%s)
NOW=$(date +%s)


# $1: The time you want to modify (e.g. now)
# $2: The amount of time you want change $1 by
# Ten minutes (600 seconds) from now would be:
#
#     before `date +%s` 600  
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
TWILIGHT=$(after $SUNSET 10800) # 3 hours after sunset

if [ $NOW -gt $TWIRISE ] && [ $NOW -lt $TWILIGHT ];
  then
    at -f $TL/takesomepics.sh `oneminlater` >> $TL/tl_info.log 2>&1
  else
    #TODO: $TWIRISE needs to be updated for tomorrow
    echo "I will start taking pictures in $(date -d @$(($TWIRISE - $NOW)) +%H:%M)" 
fi
