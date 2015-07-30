#!/bin/bash

#Returns one minute from now in Hour:Minute format (e.g. 18:50)
function oneminlater {
  date -d "@$(($(date +%s) + 60))" +%H:%M
}

if [ $(./shouldi.sh) ]
  then
    at -f ./takeapic.sh `oneminlater`
fi
