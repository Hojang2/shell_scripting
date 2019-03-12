#!/bin/bash

#This is how we define function
function test_shadow(){
	if [ -e /etc/shadow ]; then
		echo "It exist"
		test_password
	else
		echo "The file does not exist"
	fi

}

function test_password(){
	if [ -e /etc/passwd ]; then
		echo "Yes It exist"
	else
		echo "The file does not exist"
	fi
}
test_shadow
