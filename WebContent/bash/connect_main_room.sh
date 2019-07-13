#!/bin/bash

output=$(eval "pgrep appSensori")
if [ "$output" = "" ]; then
	eval "/home/pi/appSensori/appSensori > /home/pi/app.log &"
fi