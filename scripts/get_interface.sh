#!/bin/bash

INTERFACE="$(iw dev | awk '$1=="Interface" {print $2}')"

clear

echo Now obtaining wireless interface name.
sleep 1

if [ -z "$INTERFACE" ];
then
	echo No wireless interface has been detected.
	exit 0
fi

echo Wireless interface detected with name: $INTERFACE
sleep 1

echo $INTERFACE > dumpfiles/interface.txt

