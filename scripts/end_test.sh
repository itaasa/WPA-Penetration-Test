#!/bin/bash

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
