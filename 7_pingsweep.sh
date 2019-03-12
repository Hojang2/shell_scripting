#!/bin/bash

#Simple Pingsweep Script

#read -p "Please enter the subnet: " SUBNET

SUBNET="192.168.212"

HOSTS=()
INDEX=0
for IP in $(seq 184 185); do
	echo $SUBNET.$IP
	HOSTS[$INDEX]="$(ping -c 1 $SUBNET.$IP)"
	INDEX=$((INDEX+1))
done


for HOST in $(seq 0 $INDEX); do
	echo "New line"
	EXIST=$(echo "${HOSTS[$HOST]}" | grep -v Unreachable)
	echo $EXIST
	EXIST=$(echo $EXIST | grep PING | cut -c1-4  )
	echo $EXIST
	if [ $EXIST="PING" ]; then
		echo  "${HOSTS[$HOST]}"
	fi
done
