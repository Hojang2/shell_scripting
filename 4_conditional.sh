#!/bin/bash

read -p "Please enter your username: " NAME

if [ "$NAME" = "Elliot" ];
then
	echo "Welcome Elliot"
else
	echo "Please register"
fi
