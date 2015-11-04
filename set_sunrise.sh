#!/bin/bash

API=`cat wunderground_api_key`
JSON=`curl "http://api.wunderground.com/api/$API/astronomy/q/Japan/Tokyo.json"`

echo $JSON > $TL/tl_info.log 2>&1 $TL/wunderground.json

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

get_sunrise > $TL/sunrise
get_sunset > $TL/sunset
