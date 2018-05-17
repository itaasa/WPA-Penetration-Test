#!/bin/bash

./check_psk.sh
PSKFILE=`cat dumpfiles/validpsk.txt`

if [ -n "$PSKFILE" ]
then
	./quick_dictionary.sh $PSKFILE
fi
