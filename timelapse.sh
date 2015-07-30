#!/bin/bash

TL=/usr/local/google/home/pkraker/timelapse

#Dates are expressed as seconds from epoch
SUNRISE=$(date -d $(cat $TL/sunrise) +%s)
SUNSET=$(date -d $(cat $TL/sunset) +%s)
NOW=$(date +%s)

function tenminbefore {
  echo $(($1 - 600))
}

function tenminafter {
  echo $(($1 + 6000))
}

#Returns one minute from now in Hour:Minute format (e.g. 18:50)
function oneminlater {
  date -d "@$(($(date +%s) + 60))" +%H:%M
}

TWIRISE=$(tenminbefore $SUNRISE)
TWILIGHT=$(tenminafter $SUNSET)

if [ $NOW -gt $TWIRISE ] && [ $NOW -lt $TWILIGHT ];
  then
    at -f $TL/takeapic.sh `oneminlater` >> $TL/tl_info.log 2>&1
  else
    echo "I will start taking pictures in $(date -d @$(($TWIRISE - $NOW)) +%H:%M)"
#    echo "The time is $(date +%d_%H:%M)" >>  $TL/tl_info.log
#    echo "Sunrise is scheduled for $(date -d @$SUNRISE +%d_%H:%M)" >>  $TL/tl_info.log
#    echo "Sunset is scheduled for $(date -d @$SUNSET +%d_%H:%M)" >>  $TL/tl_info.log
#    echo >>  $TL/tl_info.log
fi
