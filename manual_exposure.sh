#!/bin/bash
TL=/usr/local/google/home/pkraker/timelapse

#Dates are expressed as seconds from epoch
SUNRISE=$(date -d $(cat $TL/sunrise) +%s)
SUNSET=$(date -d $(cat $TL/sunset) +%s)
NOW=$(date +%s)
TIMESTAMP=$(date +%D-%H%M%S)
CAMERA=/dev/video0

function before {
  echo $(($1 - $2))
}

function after {
  echo $(($1 + $2))
}

function get_exposure_setting {
  test=`v4l2-ctl -d $CAMERA -C exposure_auto`
  if [ "$test" == "exposure_auto: 3" ];
    then
      echo "Auto" 
  elif [ "$test" == "exposure_auto: 1" ];
    then
      echo "Manual" 
  fi
}

function set_exposure {
  echo "$TIMESTAMP  Setting exposure to $1" >> $TL/exposure_dryrun
  if [[ $(get_exposure_setting) == "Auto" ]]; then 
      echo "$TIMESTAMP  Cannot manually set exposure. Exposure is Auto" >> $TL/exposure.log
    elif [[ $(get_exposure_setting) == "Manual" ]]; then
      echo "$TIMESTAMP  Setting exposure to $1" >> $TL/exposure.log
      #v4l2-ctl -d $CAMERA -c exposure_absolute=$1 2>> $TL/exposure.log
  fi
}

# Starting 20 minutes before sunrise, 
# lower exposure by 10 every 24 seconds
# (If the exposure starts at 500, we will reach lowest exposure (3) by sunrise.)
#
# Starting 20 minutes after sunset,
# Raise the exposure by 10 every 24 seconds, until it hits 500
#
# START_LOWERING   <-- 20 mins -->     Sunrise
# Sunrise          <-- All day -->     Sunset
# Sunset           <-- 20 mins -->     START_RAISING
# START RAISING    <-- All night -->   START_LOWERING

START_LOWERING=$(before $SUNRISE 1200) # 20 minutes before sunrise
START_RAISING=$(after $SUNSET 1200) # 20 minutes after sunset

if [ $NOW -gt $START_LOWERING ] && [ $NOW -lt $SUNRISE ]; #20 mins before sunrise
  then
    #EXPOSURE=503
    until [ $EXPOSURE -lt 10 ]; do
      set_exposure $EXPOSURE
      let EXPOSURE-=10
      sleep 24;
    done
elif [ $NOW -lt $START_RAISING ] && [ $NOW -gt $SUNSET ]; #20 mins After Sunset
  then
    #EXPOSURE=3
    until [ $EXPOSURE -gt 503 ]; do
      set_exposure $EXPOSURE
      let EXPOSURE+=10
      sleep 24;
    done
elif [ $NOW -gt $START_RAISING ]; #Overnight 
#elif [ $NOW -lt $START_LOWERING ] && [ $NOW -gt $START_RAISING ]; #Overnight 
  then
    set_exposure 500
elif [ $NOW -gt $SUNRISE ] && [ $NOW -lt $SUNSET ]; #After Sunrise, before sunset (i.e. Day)
  then
    set_exposure 3
fi
