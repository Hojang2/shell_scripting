#!/bin/bash

echo "Execution of script: $0"
echo "Please enter the name of the user:$1"


#Adding user

if [ $1 = "Y" ]; then
	adduser --home /home/$2 $2
else
	echo "If you want to create user set 1 paramether to Y"
fi
