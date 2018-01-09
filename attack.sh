#!/bin/sh

#-------------------------#
# User defined functions:
#-------------------------#

#obtain name of interface used for attack
obtain_interface (){
	INTERFACE="$(iw dev | awk '$1=="Interface" {print $2}')"

	echo "Now obtaining wireless interface name."
	sleep 1

	if [ -z "$INTERFACE" ];
	then
		echo No wireless interface has been detected.
		exit 0
	fi

	echo Wireless interface detected with name: $INTERFACE
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
	printf "\n"
	echo "-----------------"
	echo " Main Menu"
	echo "-----------------"
	echo "1. Reaver"
	echo "2. Crunch"
	echo "3. Wordlist"
	echo "4. Deauthenticate"
	echo "0. Exit"
	echo "-----------------"
}

#checks if user knows client and AP MAC Addresses
menu_deauth (){
	local KNOWN
	read -p "Is MAC Address of AP known? [Y/N] " KNOWN

	case $KNOWN in
		Y|y) known_deauth ;;
		N|n) echo unknown ;;
                *) echo "Entered invalid option..." && sleep 2 && deauth
	esac
}

#allows user to quickly deauth client or ap when mac addresses are known
known_deauth () {
	local APMAC CLMAC
	read -p "Enter MAC Address of AP: " APMAC
	read -p "Enter MAC Address of client (leave blank if unknown): " CLMAC

	x-terminal-emulator -e "airodump-ng -w temp $INTERFACE" &

	#blink echo whats is occuring with airodump
	sleep 30
	local CH
	CH= awk -F "\"*, \"*" '$1=="'$APMAC'" {print $4}' temp-01.csv
	if [	-z $CH	]; then
		echo Unable to capture beacon with BSSID: $APMAC
		exit
	fi
	#now run airodump with CH
}

#read main menu choice
read_main_menu () {
	local CHOICE
	read -p "Enter choice [0-4]: " CHOICE
	case $CHOICE in
		1) echo reaver ;;
		2) echo crunch ;;
		3) echo wordlist ;;
		4) menu_deauth ;;
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
