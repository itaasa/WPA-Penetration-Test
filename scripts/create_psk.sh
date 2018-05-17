#!/bin/bash

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

echo $PSKFILE > dumpfiles/psk.txt
