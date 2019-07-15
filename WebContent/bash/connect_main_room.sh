#!/bin/bash

output=$(eval "pgrep appSensori")
if [ "$output" != "" ]; then
  eval "sudo kill -9 '$output'"
fi

eval "/home/pi/appSensori/appSensori > /home/pi/app.log &"