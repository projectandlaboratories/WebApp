#!/bin/bash

ssid='"'$1'"'
password='"'$2'"'

eval "sudo chmod -R 777 /etc/wpa_supplicant/"

eval "sudo ifconfig wlan0 down"

eval "sudo echo 'ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=IT

network={
	ssid=$ssid
	psk=$password
	key_mgmt=WPA-PSK
}' > /etc/wpa_supplicant/wpa_supplicant.conf" 

sleep 3
eval "sudo systemctl restart dhcpcd"

sleep 17

output=$(eval "iwgetid")
echo $output