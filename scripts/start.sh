#!/bin/sh

#simple pause function
pause (){
	read -p "Press [enter] key to continue..." fackEnterKey
}

#displays intro description
show_intro (){
	clear
	printf "\n\n"
	tput setaf 4; cat logo/logo.txt
	printf "\n"
	tput setaf 3; cat logo/intro_head.txt
	echo "\e[34m#####################################################"
	tput setaf 7; cat logo/intro_desc.txt
	echo "\e[34m#####################################################"
	tput setaf 7
	printf "\n"
}

#main menu
show_main_menu (){
	clear
	printf "\n"
	
	echo "\e[34m#####################################################"
	tput setaf 3; cat logo/main_menu.txt
	echo 
	echo "\e[34m#####################################################"	
	echo
	tput setaf 7;
	echo "1. Full Attack - AP and Client MACs UNKNOWN"
	echo "2. Quick Attack - AP and Client MACs KNOWN"
	echo "3. Dictionary - Valid WPA Handshake exists"
	echo "4. Exit"
	echo
	echo "Note: Option 2 can be done through command line options. See README.txt"	
	tput setaf 7;
	echo
	echo "\e[34m#####################################################"
	echo
	tput setaf 7;
}

#read main menu choice
read_main_menu () {
	local CHOICE
	read -p "Enter choice [1-4]: " CHOICE
	case $CHOICE in
		1) ./fulltest.sh ;;
		2) ./quicktest.sh ;;
		3) ./dictionary.sh ;;
		4) echo "Now exiting..." && sleep 1 && exit 0 ;;
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
