#!/bin/bash

cd crackfiles
LASTFILE=`ls | tail -n 1`

if [ ! -z "$LASTFILE" ]
then 
	CRACKFILES=(*)
	echo "Script found the following psk files: "
	ls | grep "\bcap\b"
	echo
	IS_INVALID=true

	read -p "Enter file name for psk: " PSKFILE
	
	cd ..

	while [[ "$IS_INVALID" = true ]]
	do
		for FILE in "${CRACKFILES[@]}"	
		do
			
			if [[ "$FILE" = *"$PSKFILE"* ]]
			then
				IS_INVALID=false
				echo $PSKFILE*.psk exists...
				sleep 1
				echo $PSKFILE > dumpfiles/validpsk.txt
				break
			fi
		done

		if [[ "$FILE" = "$LASTFILE" ]]
		then
			echo No such psk file named $PSKFILE!
			IS_VALID=true
			read -p "Enter file name for psk: " PSKFILE
		fi	
	
	done

else
	cd ..
	echo > dumpfiles/validpsk.txt	
	echo "No psk files have been made, run full test!"
	./end_test.sh
fi





