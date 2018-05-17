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
	echo "1. Full Test - AP/Client MACs unknown"
	echo "2. Dictionary - Valid WPA Handshake exists"
	echo "3. Exit"
	tput setaf 7;
	echo
	echo "\e[34m#####################################################"
	echo
	tput setaf 7;
}

#read main menu choice
read_main_menu () {
	local CHOICE
	read -p "Enter choice [1-3]: :" CHOICE
	case $CHOICE in
		1) ./full_test.sh ;;
		2) ./dictionary_test.sh ;;
		3) echo "Now exiting..." && sleep 1 && exit 0 ;;
		*) echo "Entered invalid option..." && sleep 2 && read_main_menu
	esac
}


#------------------MAIN EXECUTION--------------------------#

show_intro
pause
show_main_menu
read_main_menu
