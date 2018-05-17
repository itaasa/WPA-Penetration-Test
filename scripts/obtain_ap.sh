#!/bin/bash

INTERFACE=$1

x-terminal-emulator -e "airodump-ng -w dumpfiles/dump $INTERFACE" &

echo
echo "Now displaying possible targets..."
sleep 2

read -p "Enter target Access Point MAC Address: " APMAC
read -p "Enter target Client MAC Address: " CLMAC
sleep 1


# Finds PID of airodump-ng and kills it
TEMPPID=`ps -ef | grep "\bairodump-ng -w dumpfiles/dump $INTERFACE\b" | awk '{print $2}'`
kill 15 $TEMPPID

echo $APMAC > dumpfiles/ap.txt
echo $CLMAC > dumpfiles/cl.txt
