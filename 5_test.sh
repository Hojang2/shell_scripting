#!/bin/bash

if [ -e /etc/shadow ];
then
	echo "Yes it exist"
else
	echo "The file does not exist"
fi
