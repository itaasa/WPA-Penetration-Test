#!/bin/sh

INTERFACE="$(iw dev | awk '$1=="Interface" {print $2}')"

ifconfig $INTERFACE down
iwconfig $INTERFACE mode managed
ifconfig $INTERFACE up

echo "Network card: {$INTERFACE} is no longer in monitor mode."
