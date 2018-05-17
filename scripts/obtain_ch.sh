#!/bin/bash

APMAC=$1

echo
echo "Retrieving $APMAC channel..."
sleep 1

# Obtains the channel of the input BSSID from the dump files of the airodump-ng above
CH=$(awk -F "\"*, \"*" '$1=="'$APMAC'" {print $4}' dumpfiles/dump-01.csv)

echo $APMAC found on channel: $CH
sleep 1

echo $APMAC > dumpfiles/ch.txt
