#!/bin/bash

DATE=$(echo $(ping -c 1 192.168.10.25) | grep -v Unreachable)

echo "*${DATE}*"
