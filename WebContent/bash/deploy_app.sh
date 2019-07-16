#!/bin/bash

eval "sudo wget "$1

sleep 15

eval "sudo cp WebApp.war /opt/tomcat/webapps"

sleep 15

eval "sudo rm WebApp.war"

eval "sudo reboot"