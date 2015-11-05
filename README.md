# Timelapse

A series of bash scripts to take a photo every 30 seconds, create a video,
then upload the video to YouTube.  

This script will only take videos ~an hour before sunrise until after
sunset. 

Client Configuration:
Set cron to run timelapse.sh every minute.
Set the environment variable $TL to the directory of these scripts
  Note: I set this in my Crontab.
Get an API key from wunderground (http://api.wunderground.com/weather/api/)

