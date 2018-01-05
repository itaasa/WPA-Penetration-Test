#!/bin/sh

#-------------------------#
# User defined functions:
#-------------------------#

#changes wireless interface to monitor mode

obtain_interface (){
	INTERFACE="$(iw dev | awk '$1=="Interface" {print $2}')"

	if [ -z "$INTERFACE"  ];
	then
		echo No wireless interface has been detected.
		exit 0
	fi

	echo Wireless interface detected with name: $INTERFACE
}

monitor_mode (){
	echo Now switching wireless interface to monitor mode...
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
	tput setaf 3; cat intro_head.txt
	echo "\e[34m#####################################################"
	tput setaf 7; cat intro_desc.txt
	echo "\e[34m#####################################################"
	tput setaf 7
}


#------------------MAIN EXECUTION--------------------------#

show_intro
pause
obtain_interface
monitor_mode
