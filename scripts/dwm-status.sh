#!/bin/bash

setup () {
	mic=$([[ $(pulsemixer --id source-1 --get-mute) == 1 ]] && printf "[MIC: muted]")
	volume=$([[ $(pulsemixer --id sink-0 --get-mute) == 1 ]] && printf "[VOL: muted]" || pulsemixer --id sink-0 --get-volume | awk '{print "[VOL: "$1"%]"}') 
	mem=$(free -m | awk '/Mem/ {print "[MEM: "$3+$5"]"}')
	con=$(nmcli connection show | awk '/con/ {print "["$5"]"}')
	date=$(date "+[%H:%M %d-%m-%Y]")
}

while setup
do
	xsetroot -name "$mic $volume $mem $con $date"
	sleep 1
done
