#!/bin/bash

echo "Do you want to install this softwar?"

CHOICES="y n"

select OPTION in $CHOICES; do
	echo "The selected option is $REPLY"
	echo "The selected choice is $OPTION"

done
