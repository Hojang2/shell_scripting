#!/bin/bash

#---------------------------------
# Souèást hry Obì¹enec
#---------------------------------
# Poslední modifikace: 4.11. 2003
#        Znaková sada: ISO-8859-2
#---------------------------------

trap 'exit 0' TERM

if [ $# -eq 2 ]; then
  sleep $2

  if [ $(ps -p $1 -o pid | wc -l) -ge 2 ]; then
    kill -SIGTERM $1
  fi
fi

exit 0
