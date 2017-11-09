#!/bin/bash

API=`cat $TL/wunderground_api_key`

# Modify the URL for your own locality
#JSON=`curl "http://api.wunderground.com/api/$API/astronomy/q/Japan/Tokyo.json"`
#JSON=`curl "http://api.wunderground.com/api/$API/astronomy/q/us/mi/detroit.json"`
JSON=`curl "http://api.wunderground.com/api/$API/astronomy/q/us/wa/seattle.json"`

echo $JSON >> $TL/tl_info.log 2>&1 $TL/timelapse/wunderground.json

function get_sunrise {

	HOUR=`echo $JSON | jq ".sun_phase.sunrise.hour" | sed -e "s/\"//g"`
	MINUTE=`echo $JSON | jq ".sun_phase.sunrise.minute" | sed -e "s/\"//g"` 
	
	echo "$HOUR:$MINUTE"

	HOUR=""
	MINUTE=""
}

function get_sunset {

	HOUR=`echo $JSON | jq ".sun_phase.sunset.hour" | sed -e "s/\"//g"`
	MINUTE=`echo $JSON | jq ".sun_phase.sunset.minute" | sed -e "s/\"//g"` 
	
	echo "$HOUR:$MINUTE"

	HOUR=""
	MINUTE=""
}

# Main routine 

# Check to see if the wunderground API call was sucessful
SUNRISE=`get_sunrise`
SUNSET=`get_sunset`

if [[ $SUNRISE == ":"  ]]; then
  echo $SUNRISE 
  echo $SUNSET
  echo " [ set_sunrise ] - Wunderground couldn't be reached, or there was another error."
else
  echo $SUNRISE 
  echo $SUNSET

  # Here is where the sunrise and sunset are set
  get_sunrise > $TL/sunrise
  get_sunset > $TL/sunset
fi
