#!/bin/bash

# This script monitors the availability of a service, of which the name
# has been specified as a boot argument for the script. The script would
# run indefintely, and if the service that it monitors stops, it should
# do three things: Restart the service, Write a message to syslog, and
# Send an email message to the root user.
#
# Usage: ./adv_exercise1 <service_name>
#
#### Exit Code Documentation
# 3: No argument provided.
# 4: Service is not running.
####

# Make sure that service name is provided as an argument,
if [ -z $1 ]; then
  echo You need to provide a service name when starting this script.
  exit 3
else
  SERVICE=$1
fi

# Run without stopping to do the monitoring task.
## Verify that $SERVICE is running.
if ps aux | grep $SERVICE | grep -v grep | grep -v adv_exercise1
then
  echo All good.
else
  echo $SERVICE could not be found as a process.
  echo Make sure that $SERVICE is running, and try again.
  echo The commnand '"ps aux | grep $SERVICE | grep -v grep | grep -v adv_exercise1"' should show the service up and running.
  exit 4
fi

## Monitor $SERVICE.
while ps aux | grep $SERVICE | grep -v grep | grep -v adv_exercise1
do
  echo All good.
  sleep 5
done

# Actions if service fails.
# Assumes service processname can be started with the "service" command.
## Restart $SERVICE.
service $SERVICE start

## Write message to syslog.
logger adv_exercise1: $SERVICE restarted

## Send email to root user.
mail -s "adv_exercise1: $SERVICE restarted at $(date +%d-%m-%Y %H:%M)" root < .
