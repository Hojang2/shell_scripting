#!/bin/bash

#========================================================================
#     Obì¹enec 1.1
#     Copyright (C) 2002-2003  Jan Fuchs
#------------------------------------------------------------------------
#     E-mail: fuky@seif.cz
#        Web: http://www.seif.cz
#------------------------------------------------------------------------
#     Poslední modifikace: 12.11. 2003
#            Znaková sada: ISO-8859-2
#------------------------------------------------------------------------
#     Tento program je volné programové vybavení; mù¾ete jej ¹íøit a
# modifikovat podle ustanovení Obecné veøejné licence GNU, vydávané Free
# Software Foundation; a to buï verze 2 této licence anebo (podle va¹eho
# uvá¾ení) kterékoli pozdìj¹í verze.
#------------------------------------------------------------------------
#     Tento program je roz¹iøován v nadìji, ¾e bude u¾iteèný, av¹ak BEZ
# JAKÉKOLI ZÁRUKY; neposkytují se ani odvozené záruky PRODEJNOSTI anebo
# VHODNOSTI PRO URÈITÝ ÚÈEL.
# Dal¹í podrobnosti hledejte v Obecné veøejné licenci GNU.
#------------------------------------------------------------------------
#    Kopii Obecné veøejné licence GNU jste mìl obdr¾et spolu s tímto
# programem; pokud se tak nestalo, napi¹te o ni Free Software Foundation,
# Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#========================================================================

PID_OBESENCE=$$

etc="/usr/local/etc"
share="/usr/local/share/obesenec"

function napoveda() {
  echo "obesenec.sh:"
  echo "-h, --help vypí¹e nápovìdu"
  echo "-d         zapne xtrace"
} # napoveda()

if [ "$1" == "-d" ]; then
  set -o xtrace
elif [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  napoveda
  exit 0
elif [ "$1" ]; then
  echo "Neznámý pøepínaè: $1"
  napoveda
  exit 0
fi

function cas_vyprsel() {
  konec=10
  vypis_prohra
} # cas_vyprsel()

trap 'cas_vyprsel' TERM

function stopky_start() {
  if [ "$time" != "0" ]; then
    "${share}/stopky.sh" $PID_OBESENCE $time &
    PID_STOPEK=$!
  fi
} # stopky_start()

function stopky_stop() {
  if [ "$time" != "0" ] &&
     [ "$PID_STOPEK" ] &&
     [ $(ps -p $PID_STOPEK -o pid | wc -l) -ge 2 ]; then
    kill -SIGTERM $PID_STOPEK
  fi
} # stopky_stop()

function vypis_hlavicka() {
  echo "_________"
  echo " Pøíkazy "
  echo "~~~~~~~~~"
  echo "nh - nová hra"
  echo "end - konec programu"
  echo "licence - licenèní úmluvy"
  echo "__________"
  echo " Obì¹enec "
  echo "~~~~~~~~~~"
} # vypis_hlavicka()

function vypis_konec() {
  stopky_start
  echo -n "Zadej znak nebo pøíkaz: "
  read retezec
} # vypis_konec()

function vypis_prohra() {
  clear
  vypis_hlavicka
  head -n130 "${share}/obesenec.obr" | tail -n13
  echo
  echo "Tipované slovo (vìta): $slovo"
  echo "Prohrál(a) jsi."
  sleep 2
  echo
  echo -n "Stiskni ENTER"
} # vypis_prohra()

function vypis_vyhra() {
  clear
  vypis_hlavicka
  echo "Tipované slovo (vìta): $slovo"
  echo "Vyhrál(a) jsi."
  echo -n "Zadej pøíkaz: ";
  read retezec
} # vypis_vyhra()

function obes() {
  pozice=$(($chyba * 13))
  head -n$pozice "${share}/obesenec.obr" | tail -n13
} # obes()

function pridej_znaky() {
  znak_dia=""
  znak_vel=""

  if [ "$rozliseni" == "nic" ] || [ "$rozliseni" == "velikost" ]; then
    znak_dia=$(echo $retezec_por | tr 'riseztcyundao' 'øí¹ì¾»èýùòïáó')
    znak_dia="$znak_dia$(echo $retezec_por | tr 'riseztcyundao' 'ØÍ©Ì®«ÈÝÙÒÏÁÓ')"
    znak_dia="$znak_dia$(echo $retezec_por | tr 'ue' 'úé')"
    znak_dia="$znak_dia$(echo $retezec_por | tr 'ue' 'ÚÉ')"
  fi

  if [ "$rozliseni" == "nic" ] || [ "$rozliseni" == "diakritika" ]; then
    znak_vel=$(echo "$retezec_por" | tr [:lower:] [:upper:])
  fi

  echo "$znak_dia$znak_vel"
} # pridej_znaky()

function kontrola() {
  if [ "$konec" -eq "10" ]; then
    vypis_hlavicka
    echo -n "Zadej pøíkaz: "
    read retezec
  else
    vypis_hlavicka

    if [ $(expr index "$slovo_por" $retezec_por) -eq 0 ]; then
      chyba=$(($chyba + 1))
      chybne_znaky="$chybne_znaky$retezec"
      if [ "$chyba" -eq "10" ]; then
        konec=10
        vypis_prohra
        return;
      fi
    else
      if [ $(expr index "$nalezene_znaky" $retezec_por) -eq 0 ]; then
        nalezene_znaky="$nalezene_znaky$retezec_por"
	znak_pri=$(pridej_znaky)
        nalezene_znaky="$nalezene_znaky$znak_pri"
	slovo_tip=$(echo $slovo | sed "s/[^$nalezene_znaky]/-/g")

        if [ $(expr index "$slovo_tip" "-") -eq 0 ]; then
          konec=10
          vypis_vyhra
          return;
        fi
      fi
    fi

    obes
    echo

    echo "Nalezené znaky: $nalezene_znaky"
    echo "Tipované slovo (vìta): $slovo_tip"

    if ! $([ -z "$chybne_znaky" ]); then
      echo "Slovo neobsahuje: $chybne_znaky"
    fi

    vypis_konec
  fi
} # kontrola()

function modifikace() {
  if [ "$rozliseni" == "nic" ]; then
    echo $(echo "$1" | tr [:upper:] [:lower:] | tr 'øí¹ì¾»èýùòúïáéó' 'riseztcyunudaeo')
  elif [ "$rozliseni" == "velikost" ]; then
    echo $(echo "$1" | tr 'øí¹ì¾»èýùòúïáéóØÍ©Ì®«ÈÝÙÒÚÏÁÉÓ' 'riseztcyunudaeoRISEZTCYUNUDAEO')
  elif [ "$rozliseni" == "diakritika" ]; then
    echo $(echo "$1" | tr [:upper:] [:lower:])
  elif [ "$rozliseni" == "all" ]; then
    echo $1
  fi
} # modifikace()

function nova_hra() {
  stopky_stop

  cislo=$(($RANDOM % $(($typ + 1))))
  nahodny_radek=$(($RANDOM % $(wc -l "${share}/obesenec${cislo}.dat" | sed 's/^ *\([0123456789]\+\).*$/\1/')))

  if [ "$nahodny_radek" -eq "0" ]; then
    nahodny_radek=1
  fi

  slovo=$(head -n$nahodny_radek "${share}/obesenec${cislo}.dat" | tail -n1)
  slovo_delka=${#slovo}

  slovo_por=$(modifikace "$slovo")
  slovo_tip=$(echo "$slovo" | sed 's/[^ .!?,]/-/g')

  nalezene_znaky=".!?, "
  chybne_znaky=""
  chyba=0
  konec=0

  vypis_hlavicka
  echo "Tipované slovo (vìta): $slovo_tip"
  vypis_konec
} # nova_hra()

function soubory_existence() {
  soubor_neni=0

  i=0
  while [ $i -le 9 ]; do
    if ! $([ -e "${share}/obesenec${i}.dat" ]); then
      soubor_neni=1
      echo "Soubor ${share}/obesenec${i}.dat neexistuje!"
    fi
    i=$(($i + 1))
  done

  if ! $([ -e "${share}/obesenec.obr" ]); then
    soubor_neni=1
    echo "Soubor ${share}/obesenec.obr neexistuje!"
  fi

  if ! $([ -e "${etc}/obesenec.conf" ]); then
    soubor_neni=1
    echo "Soubor ${etc}/obesenec.conf neexistuje!"
  fi

  if ! $([ -e "${share}/stopky.sh" ]); then
    soubor_neni=1
    echo "Soubor stopky neexistuje!"
  fi

  if [ "$soubor_neni" -eq "1" ]; then
    exit 1
  fi
} # soubory_existence()

function konfigurace() {
  typ=0
  rozliseni=nic
  time=0

  typ=$(cat "${etc}/obesenec.conf" | sed -n 's/^typ=\(.\+\)$/\1/p')
  rozliseni=$(cat "${etc}/obesenec.conf" | sed -n 's/^rozliseni=\(.\+\)$/\1/p')
  time=$(cat "${etc}/obesenec.conf" | sed -n 's/^time=\(.\+\)$/\1/p')
} # konfigurace()

clear
soubory_existence
konfigurace

echo "_______________________________________________________"
echo " Obì¹enec verze 1.1, Copyright (C) 2002-2003 Jan Fuchs "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "    Obì¹enec je ABSOLUTNÌ BEZ ZÁRUKY; podrobnosti se dozvíte zadáním"
echo "pøíkazu licence. Jde o volné programové vybavení a jeho ¹íøení za"
echo "jistých podmínek je vítáno; podrobnosti získáte zadáním pøíkazu licence."

nova_hra

while :
do
  clear

  if [ -z "$retezec" ]; then
    vypis_hlavicka

    if [ "$konec" -eq "10" ]; then
      echo -n "Zadej pøíkaz: "
    else
      echo -n "Zadej znak nebo pøíkaz: "
    fi

    read retezec
  else
    retezec_por=$(modifikace "$retezec")

    case "$retezec" in
      "nh" )
        clear
        nova_hra;;

      "end" )
        exit 0
        ;;
        "cheat" )
        vypis_vyhra;;

      "licence" )
        if [ -e "${share}/licence.cs" ]
        then
          less "${share}/licence.cs"
          clear
        else
          echo "Soubor ${share}/licence.cs nebyl nalezen!!!"
          echo
        fi

        nova_hra
        ;;

      [a-z] | [A-Z] )
        stopky_stop
        kontrola
	;;

      * )
	vypis_hlavicka
        echo "Zadal(a) jsi nepovolený znak èi pøíkaz!!!"
        echo -n "Zadej znak nebo pøíkaz: "
        read retezec
        ;;
    esac
  fi
done

exit 0
