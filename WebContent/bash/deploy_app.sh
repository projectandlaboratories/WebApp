#!/bin/bash

eval "sudo wget "$1

sleep 10

eval "sudo cp WebApp.war /opt/tomcat/webapps"