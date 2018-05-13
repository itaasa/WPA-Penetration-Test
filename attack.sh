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
	echo "1. Reaver - using WPS key pins"
	echo "2. Wordlist - uses public wordlist found in /wordlists"
	echo "0. Exit"
	tput setaf 7;
	echo
	echo "\e[34m#####################################################"
	echo
	tput setaf 7;
}

#read main menu choice
read_main_menu () {
	local CHOICE
	read -p "Enter choice [0-2]: " CHOICE
	case $CHOICE in
		1) ./reaver.sh ;;
		2) ./wordlist.sh ;;
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
