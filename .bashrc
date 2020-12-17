#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx

export HISTFILESIZE=2000
export HISTCONTROL=ignoredups:erasedups
export EDITOR="vim"
export VISUAL="code"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# auto cd into directory if not valid command
shopt -s autocd

# enable vi mode
set -o vi
bind -m vi-command 'Control-l: clear-sceen'
bind -m vi-insert 'Control-l: clear-screen'

alias ..='cd ..'
alias ll='ls -lh'
alias la='ls -lah'
alias lle='exa -l --color=always'
alias lae='exa -la --color=always'

# git
alias pacsyu='sudo pacman -Syu'
alias pacs='sudo pacman -S'
alias pacss='pacman -Ss'

# git
alias gits='git status'
alias gitcm='git commit -m'

# apps
alias r='ranger'
alias flameshot='flameshot gui -d 2000'
alias ff='firefox'
alias ffinc='firefox --private-window'

# webcam
alias camoff='sudo modprobe -r uvcvideo'
alias camon='sudo modprobe uvcvideo'

# system
alias clear='clear; ~/scripts/hellofriend.sh'
alias battery='cat /sys/class/power_supply/BAT0/capacity | while read x ; do echo BAT0 = $x % ; done'
alias poff='shutdown 0'

## get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

# youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

# for color output
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# man color
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}


# usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;      
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

NC="\[\033[0m\]"
BHIPurple="\[\033[1;95m\]"
Red="\[\033[0;31m\]"
Green="\[\033[0;32m\]"
HICyan="\[\033[0;96m\]"


#PS1="${BHIPurple}\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[${Red}\342\234\227${BHIPurple}]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '${Red}\h'; else echo "${HICyan}\h"; fi)${BHIPurple}]\342\224\200[${Green}\w${BHIPurple}]\n${BHIPurple}\342\224\224\342\224\200\342\224\200> ${NC}"

# more readable PS1
PS1="${BHIPurple}┌─\
\$([[ \$? != 0 ]] && echo \"[${Red}✗${BHIPurple}]─\")\
[$(if [[ ${EUID} == 0 ]]; then echo '${Red}\h'; else echo "${HICyan}\h"; fi)${BHIPurple}]─[${Green}\w${BHIPurple}]\n\
${BHIPurple}└──> ${NC}"


neofetch  -L --ascii_colors 13 13 | lolcat
