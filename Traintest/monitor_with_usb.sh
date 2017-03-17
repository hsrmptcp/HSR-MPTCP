#!/bin/bash

list_iface=()
list_carrier=()
list_pre=()
list_cur=()
list_speed=()

function get_iface
{
    for iface in `ls /sys/class/net/ | grep usb`; do
	if [ `cat /sys/class/net/${iface}/operstate` = "unknown" ]; then
	    list_iface+=(${iface})
	    
	fi
    done
}

function get_carrier
{
    for iface in ${list_iface[@]}; do
	carrier_mac=`ifconfig ${iface} | grep HWaddr | awk '{ print $NF }'`
	    # list_carrier+=(${carrier_mac})
	    case "${carrier_mac}" in
		*Mobile* | *mobile* ) carrier="Mobile" ;;
		36:4b:50:b7:ef:40 )   carrier="Unicom" ;;
		36:4b:50:b7:ef:61 )   carrier="Telcom" ;;
	    esac
	list_carrier+=(${carrier})
    done
}

function monitor
{
    j=0
    for iface in ${list_iface[@]}; do
	list_pre[j]=`cat /sys/class/net/${iface}/statistics/rx_bytes`
	(( j++ ))
    done

    sleep 1

    j=0
    for iface in ${list_iface[@]}; do
	list_cur[j]=`cat /sys/class/net/${iface}/statistics/rx_bytes`
	list_speed[j]=${list_cur[j]}-${list_pre[j]}
	(( list_speed[j] /= 1024 ))

	list_pre=${list_cur}
	(( j++ ))
    done
}

get_iface
get_carrier

clear

while true; do
    monitor
    j=0
    for carrier in ${list_carrier[@]}; do
	echo -ne "${list_speed[j]}KB/s (${list_carrier[j]} - ${list_iface[j]})     "
	(( j++ ))
    done
    echo -ne "\033[0K\r"
done
