#!/bin/bash

TL=/usr/local/google/home/pkraker/timelapse
JSON=`curl "http://api.wunderground.com/api/76d7dbccf8d73382/astronomy/q/Japan/Tokyo.json"`

echo $JSON > $TL/tl_info.log 2>&1 $TL/wunderground.json

function set_sunrise {
	HOUR=`echo $JSON | jq ".sun_phase.sunrise.hour" | sed -e "s/\"//g"`
	MINUTE=`echo $JSON | jq ".sun_phase.sunrise.minute" | sed -e "s/\"//g"` 
	
	echo "$HOUR:$MINUTE" > $TL/sunrise 

	HOUR=""
	MINUTE=""
}

function set_sunset {
	HOUR=`echo $JSON | jq ".sun_phase.sunset.hour" | sed -e "s/\"//g"`
	MINUTE=`echo $JSON | jq ".sun_phase.sunset.minute" | sed -e "s/\"//g"` 
	
	echo "$HOUR:$MINUTE" > $TL/sunset

	HOUR=""
	MINUTE=""
}

set_sunrise
set_sunset
