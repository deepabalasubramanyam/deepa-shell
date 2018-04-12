#!/bin/bash
# 
# This script is an optimization of the course-provided script for Exercise 7.
#
## The script monitors the top-active process. It sends an email to the user root if
## utilization of the top-active process goes beyond 80%. Once the script is started,
## it will continue to run until the user stops it.
#
# Usage: ./adv_exercise7

while sleep 10
do
  # Check if we have a process causing high CPU load every 60 seconds.
  USAGEALL=$(ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1)
  USAGE=$(echo USAGEALL | awk '{ print $1}')
  USAGE=${USAGE%.*}
  PID=$(echo USAGEALL | awk '{ print $2}')
  PNAME=$(echo USAGEALL | awk '{ print $3}')
  
  # Only if we have a high CPU load on one process, run a check within 7 seconds.
  # In this check, we should monitor if the process is still that active.
  # If that's the case, root gets a message.
  if [ $USAGE -gt 80 ]
  then
    USAGE1=$USAGE
    PID1=$PID
    PNAME1=$PNAME
    sleep 7
    USAGE2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $1 }'`
    USAGE2=${USAGE2%.*}
    PID2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $2 }'`
    PNAME2=`ps -eo pcpu,pid -o comm= | sort -k1 -n -r | head -1 | awk '{ print $3 }'`
    [ $USAGE2 -gt 80 ] && mail -s "CPU load of $PNAME is above 80%" root@blah.com < .
  fi
done
