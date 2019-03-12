#!/bin/bash

#Simple Password Generator

read -p "Enter lenght of password: " PASS_LENGHT

for PASSWORD  in $(seq 1 5);
do
	openssl rand -base64 48 | cut -c1-$PASS_LENGHT
done

