#!/bin/bash

read -p "Enter AP MAC Address: " APMAC

echo $APMAC > dumpfiles/ap.txt
