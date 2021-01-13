#!/bin/bash

watchlater="https://www.youtube.com/playlist?list="
DMENU_COLORS="-nb #222222 -nf #bbbbbb -sb #9D65C9 -sf #eeeeee"
DMENU_SETTINGS="-i -l 40"
NEW_LINE=$'\n'

chooselist() {

list=($(echo " watchlater$NEW_LINE clipboard$NEW_LINE clipboard (only ID)$NEW_LINE custom$NEW_LINE exit" | dmenu $DMENU_SETTINGS $DMENU_COLORS))
if [ $list == "watchlater" ]; then
  PLAYLIST=$watchlater
elif [ $list == "clipboard" ]; then
  PLAYLIST=$(xclip -o)
elif [ $list == "clipboard (only ID)" ]; then
  PLAYLIST="https://www.youtube.com/playlist?list="
  PLAYLIST+=$(xclip -o)
elif [ $list == "custom" ]; then
  PLAYLIST="https://www.youtube.com/playlist?list="
  PLAYLIST+=$(echo "" | dmenu -p " Enter playlist ID " $DMENU_COLORS)
elif [ $list == "exit" ]; then
  exit
else
  echo "invalid input"
  chooselist
fi

}


setup() {

playlisthtml=$(curl -s $PLAYLIST)
itemurls=($(echo $playlisthtml | grep -oP '"url":"/watch.{0,15}' | grep -oP '/watch.{0,14}'))
readarray -t itemnames <<<"$(echo $playlisthtml | grep -oP '"width":336,"height":188}]},"title":{"runs":\[{"text":.+?}' | awk -F '["]' '{print $12}')"
readarray -t itemchan <<<"$(echo $playlisthtml | grep -oP '"shortBylineText":{"runs":\[{"text":".+?"' | awk -F '["]' '{print $8}')"

declare -i y=0
declare -i end=${#itemnames[@]}
fordmenu=""

while [ $y -ne $end ]
do
  fordmenu+=" ${itemchan[y]}  ${itemnames[y]}   ${itemurls[y]}$NEW_LINE"
  y=$y+1
done
fordmenu+=" choose playlist$NEW_LINE"
fordmenu+=" refresh$NEW_LINE"
fordmenu+=" exit"

}


mainloop() {

while :
do
selection=$(printf "$fordmenu" | dmenu $DMENU_SETTINGS $DMENU_COLORS)
if [ "$selection" = " exit" ]; then
  exit
elif [ "$selection" = " refresh" ]; then
  setup
elif [ "$selection" = " choose playlist" ]; then
  chooselist
  setup
else
  mpv "https://www.youtube.com$(echo $selection | grep -oP '/watch.+')"
fi
done

}


chooselist
setup
mainloop
