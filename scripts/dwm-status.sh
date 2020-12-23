#!/bin/bash

setup () {

	mic=$([[ $(pulsemixer --id source-1 --get-mute) == 1 ]] && printf "[MIC: muted]")
	volume=$([[ $(pulsemixer --id sink-0 --get-mute) == 1 ]] && printf "[VOL: muted]" || pulsemixer --id sink-0 --get-volume | awk '{print "[VOL: "$1"%]"}') 
	backlight=$(xbacklight -get | awk '{split($0,a,"."); print "[BL: "a[1]"%]"}')
	mem=$(free -m | awk '/Mem/ {print "[MEM: "$3+$5"]"}')
	con=$(nmcli device show wlp1s0 | grep -q "disconnected" && printf "[wifi off]" || printf "[wifi on]") 
	date=$(date "+[%H:%M %d-%m-%Y]")
	battery=$(cat /sys/class/power_supply/BAT0/capacity | awk '{printf "[BAT: "$1"%]"}')

}

while setup
do
	xsetroot -name "$mic $volume $backlight $mem $con $date $battery"
	sleep 1
done
