#!/bin/bash

eval "sudo systemctl restart dhcpcd"

sleep 20

output=$(eval "iwgetid")
sleep 1
echo $output