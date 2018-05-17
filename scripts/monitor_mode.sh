#!/bin/bash

INTERFACE=$1

echo Now switching wireless interface to monitor mode...
sleep 1

ifconfig $INTERFACE down
iwconfig $INTERFACE mode monitor
ifconfig $INTERFACE up

echo Wireless interface now in monitor mode.
sleep 1
