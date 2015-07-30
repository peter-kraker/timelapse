#!/bin/bash

#Dates are expressed as seconds from epoch 
SUNRISE=$(date -d $(cat ./sunrise) +%s)
SUNSET=$(date -d $(cat ./sunset) +%s)
NOW=$(date +%s)

function tenminbefore {
  echo $(($1 - 300))
}

function tenminafter {
  echo $(($1 + 300))
}

TWIRISE=$(tenminbefore $SUNRISE)
TWILIGHT=$(tenminafter $SUNSET)

function shouldi {
  if [ $NOW -gt $TWIRISE ] && [ $NOW -lt $TWILIGHT ];
    then
      echo "yes"
    else
      echo "no" 
  fi
}

shouldi
