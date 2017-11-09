#!/bin/bash

# Script to clean up some pictures to make more space on the disk
#
# Current implementation is to delete just the oldest day's photos
# and video. This should be run only once a day. 
#
# 
# TODO: Refactor this to do the following:
#
# Delete all photos from two weeks ago

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`

# Needed to handle month rollover gracefully
# `date` doesn't do "two monday's ago", so "-2 weeks next Monday" is a hack.

DAY_TO_DELETE_FROM=`date -d "-2 weeks next Monday" +%d`
MONTH_TO_DELETE_FROM=`date -d "-2 weeks next Monday" +%m`
DAYS_IN_MONTH_FROM=`cal $(date -d "-2 weeks next Monday" +"%m %Y") | awk 'NF {DAYS = $NF}; END {print DAYS}'`

DAY_TO_DELETE_TO=`date -d "last Monday" +%d`
MONTH_TO_DELETE_TO=`date -d "last Monday" +%m`
DAYS_IN_TO_MONTH=`cal $(date -d "last Monday" +"%m %Y") | awk 'NF {DAYS = $NF}; END {print DAYS}'`
DRYRUN=0

while [[ $# >1 ]]
do
key="$1"

case $key in
  -m|--month)
  MONTH=$2
  shift
  ;;
  -d|--day)
  DAY=$2
  shift
  ;;
  -f|--format)
  FORMAT=$2
  ;;
  --dryrun)
  DRYRUN=$2
  ;;
  *)

  ;;
esac
shift
done


echo "RUNNING makesomespace.sh " >> $TL/tl_info.log

# Notes about some of the options here:
#   seq -f "%02g" -- Since we're using seq's output in traversing the
#		     stucture, we need it to be 2-digits long.
#
#  `cal $(date -d "last Monday" +"%m %Y") | awk 'NF {DAYS = $NF}; END {print DAYS}'` 
#                 -- This command parses the output of `cal` to give the last day
#			in the month
#

if [[ $DRYRUN -eq 1 ]] ; then 
  echo "... Executing dry run." >> $TL/tl_info.log
  echo "... Would delete the following files:" >> $TL/tl_info.log

	#    If we've wrapped around to the next month, i.e. the "today" date is
	#  Lower than "last Monday's" date. Delete this month's photos, then
	#  wrap around and get next months. 

	if [[ $DAY_TO_DELETE_TO < $DAY_TO_DELETE_FROM ]]; then
	  # Invoke two 'for' statements: 
	  #   1. For each folder in last month's folder, delete the folder and everything in it.
	  #   2. For each folder in this month's folder, delete the folder and everything in it.

	  for i in `seq -f "%02g" $DAY_TO_DELETE_FROM $DAYS_IN_MONTH_FROM`; do
	    ls $TL/pics/$MONTH_TO_DELETE_FROM/$i >> $TL/tl_info.log
	    ls $TL/pics/$MONTH_TO_DELETE_FROM/$i-animated.* >> $TL/tl_info.log
	  done
	  for i in `seq -f "%02g" 1 $DAY_TO_DELETE_TO`; do
	    ls $TL/pics/$MONTH_TO_DELETE_TO/$i >> $TL/tl_info.log 
	    ls $TL/pics/$MONTH_TO_DELETE_TO/$i-animated.* >> $TL/tl_info.log
	  done
	else 
	  # otherwise, just use one for loop. 
	  for i in `seq -f "%02g" $DAY_TO_DELETE_FROM $DAY_TO_DELETE_TO`; do
	    ls $TL/pics/$MONTH/$i >> $TL/tl_info.log
	    ls $TL/pics/$MONTH/$i-animated.* >> $TL/tl_info.log
	  done 
	fi

else 

	# Same structure as above
	if [[ $DAY_TO_DELETE_TO < $DAY_TO_DELETE_FROM ]]; then
	  for i in `seq -f "%02g" $DAY_TO_DELETE_FROM $DAYS_IN_MONTH_FROM`; do
	    echo "... Trying to remove $TL/pics/$MONTH_TO_DELETE_FROM/$i" >> $TL/tl_info.log
	    rm -rd $TL/pics/$MONTH_TO_DELETE_FROM/$i >> $TL/tl_info.log
	    rm -rd $TL/pics/$MONTH_TO_DELETE_FROM/$i-animated.* >> $TL/tl_info.log
	    echo "... Removed" >> $TL/tl_info.log
	  done
	  for i in `seq -f "%02g" 1 $DAY_TO_DELETE_TO`; do
	    echo "... Trying to remove $TL/pics/$MONTH_TO_DELETE_TO/$i" >> $TL/tl_info.log
	    rm -rd $TL/pics/$MONTH_TO_DELETE_TO/$i >> $TL/tl_info.log 
	    rm -rd $TL/pics/$MONTH_TO_DELETE_TO/$i-animated.* >> $TL/tl_info.log
	    echo "... Removed" >> $TL/tl_info.log
	  done
	else 
	  for i in `seq -f "%02g" $DAY_TO_DELETE_FROM $DAY_TO_DELETE_TO`; do
	    echo "... Trying to remove $TL/pics/$MONTH/$i" >> $TL/tl_info.log
	    rm -rd $TL/pics/$MONTH/$i >> $TL/tl_info.log
	    rm -rd $TL/pics/$MONTH/$i-animated.* >> $TL/tl_info.log
	    echo "... Removed" >> $TL/tl_info.log
	  done 
	fi
fi

