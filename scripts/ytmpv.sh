#!/bin/bash

watchlater="https://www.youtube.com/playlist?list=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
DMENU_COLORS="-nb #222222 -nf #bbbbbb -sb #9D65C9 -sf #eeeeee"
DMENU_SETTINGS="-i -l 40"
FILTER="[^0-9a-zA-ZΆ-ώ ]"
NEW_LINE=$'\n'

chooselist() {

list=($(echo " watchlater$NEW_LINE search$NEW_LINE clipboard$NEW_LINE clipboard (only ID)$NEW_LINE custom$NEW_LINE exit" | dmenu $DMENU_SETTINGS $DMENU_COLORS))
if [ $list == "watchlater" ]; then
  PLAYLIST=$watchlater
elif [ $list == "search" ]; then
  ytsearch
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
setup

}


setup() {

playlisthtml=$(curl -s $PLAYLIST)
itemurls=($(echo $playlisthtml | grep -oP '"url":"/watch.{0,15}' | grep -oP '/watch.{0,14}'))
readarray -t itemnames <<<"$(echo $playlisthtml | grep -oP '"width":336,"height":188}]},"title":{"runs":\[{"text":.+?}' | sed 's/\\\"//g' | awk -F '["]' '{print $12}' | sed 's/$FILTER//g')"
readarray -t itemchan <<<"$(echo $playlisthtml | grep -oP '"shortBylineText":{"runs":\[{"text":".+?"' | awk -F '["]' '{print $8}')"

declare -i y=0
declare -i end=${#itemnames[@]}
fordmenu=""

while [ $y -ne $end ]
do
  fordmenu+=" ${itemchan[y]}  ${itemnames[y]}   ${itemurls[y]}$NEW_LINE"
  y=$y+1
done
fordmenu+=" refresh$NEW_LINE"
fordmenu+=" menu$NEW_LINE"
fordmenu+=" exit"

mainloop

}


mainloop() {

while :
do
selection=$(printf "$fordmenu" | dmenu $DMENU_SETTINGS $DMENU_COLORS)
if [ "$selection" = " exit" ]; then
  exit
elif [ "$selection" = " refresh" ]; then
  setup
elif [ "$selection" = " menu" ]; then
  chooselist
else
  mpv "https://www.youtube.com$(echo $selection | grep -oP '/watch.+')"
fi
done

}


ytsearch() {

searchtype=$(echo " video$NEW_LINE channel$NEW_LINE playlist" | dmenu $DMENU_SETTINGS $DMENU_COLORS)
if [ "$searchtype" = " video" ]; then
  searchtype="\&sp=EgIQAQ%253D%253D"
elif [ "$searchtype" = " channel" ]; then
  searchtype="\&sp=EgIQAg%253D%253D"
elif [ "$searchtype" = " playlist" ]; then
  searchtype="\&sp=EgIQAw%253D%253D"
fi

searchquery=$(echo "" | dmenu -p "Search: " $DMENU_COLORS)
searchquery=$(echo $searchquery | sed 's/ /+/g')
searchhtml=$(curl -s https://www.youtube.com/results?search_query=$searchquery$searchtype)

searchurls=($(echo $searchhtml | grep -oP '"url":"/watch.{0,15}' | grep -oP '/watch.{0,14}'))
readarray -t searchnames <<<"$(echo $searchhtml | grep -oP '}\]},"title":{"runs":\[{"text":.+?}' | sed 's/\\\"//g' | awk -F '["]' '{print $8}' | sed 's/$FILTER//g')"
readarray -t searchchan <<<"$(echo $searchhtml | grep -oP '"shortBylineText":{"runs":\[{"text":".+?"' | awk -F '["]' '{print $8}')"


declare -i x=0
declare -i searchend=${#searchurls[@]}
searchdmenu=""

while [ $x -ne $searchend ]
do
  searchdmenu+=" ${searchchan[x]}  ${searchnames[x]}   ${searchurls[x]}$NEW_LINE"
  x=$x+1
done
searchdmenu+=" search$NEW_LINE"
searchdmenu+=" menu$NEW_LINE"
searchdmenu+=" exit"

while :
do
selection=$(printf "$searchdmenu" | dmenu $DMENU_SETTINGS $DMENU_COLORS)
if [ "$selection" = " search" ]; then
  ytsearch
elif [ "$selection" = " menu" ]; then
  chooselist
elif [ "$selection" = " exit" ]; then
  exit
else
  mpv "https://www.youtube.com$(echo $selection | grep -oP '/watch.+')"
fi
done


}




chooselist
