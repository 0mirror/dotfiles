#!/bin/sh

height=$(tput lines)
width=$(tput cols)

tput cup "$((0))" "$(((width/2)-6))"

printf "%s\n" "hello friend."
