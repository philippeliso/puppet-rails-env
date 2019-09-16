ANSI_ESCAPE="\\033"
ANSI_DISPLAY_RESET="0"
ANSI_DISPLAY_ATTR_BRIGHT="1"
ANSI_DISPLAY_ATTR_DIM="2"
ANSI_DISPLAY_ATTR_UNDERSCORE="4"
ANSI_DISPLAY_ATTR_BLINK="5"
ANSI_DISPLAY_ATTR_REVERSE="7"
ANSI_DISPLAY_ATTR_HIDDEN="8"
ANSI_DISPLAY_FG_BLACK="30"
ANSI_DISPLAY_FG_RED="31"
ANSI_DISPLAY_FG_GREEN="32"
ANSI_DISPLAY_FG_YELLOW="33"
ANSI_DISPLAY_FG_BLUE="34"
ANSI_DISPLAY_FG_MAGENTA="35"
ANSI_DISPLAY_FG_CYAN="36"
ANSI_DISPLAY_FG_WHITE="37"
ANSI_DISPLAY_BG_BLACK="40"
ANSI_DISPLAY_BG_RED="41"
ANSI_DISPLAY_BG_GREEN="42"
ANSI_DISPLAY_BG_YELLOW="43"
ANSI_DISPLAY_BG_BLUE="44"
ANSI_DISPLAY_BG_MAGENTA="45"
ANSI_DISPLAY_BG_CYAN="46"
ANSI_DISPLAY_BG_WHITE="47"

function ansi_display_sequence() {
  SEQUENCE="$ANSI_ESCAPE[$ANSI_DISPLAY_RESET;"
  while [ $# -ge 1 ]
  do
    SEQUENCE="${SEQUENCE}$1"
    if [ $# -gt 1 ]
    then
      SEQUENCE="${SEQUENCE};"
    fi
    shift
  done
  SEQUENCE="${SEQUENCE}m"
  echo -n "$SEQUENCE"
}

function ansi_display_sequence_ps1() {
  echo -n "\[$(ansi_display_sequence "$@")\]"
}

PS1_STATUS="\$(
  RET=\$?
  if [ \$RET -ne 0 ]
  then
    echo -ne '$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_RED)'
    echo \"(Exit \$RET) \"
  fi
  )"

if [ $UID -eq 0 ]
then
  PS1_USER_COLOR="$ANSI_DISPLAY_FG_RED"
else
  PS1_USER_COLOR="$ANSI_DISPLAY_FG_GREEN"
fi

PS1_USER="$(ansi_display_sequence_ps1 $PS1_USER_COLOR)\\u"
PS1_AT="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE)@"
PS1_HOSTNAME_ATTR="DIM"
PS1_HOSTNAME_FG="YELLOW"
PS1_HOSTNAME_BG=""
PS1_HOSTNAME="$(eval "ansi_display_sequence_ps1 \
  \$ANSI_DISPLAYATTR_$PS1_HOSTNAME_ATTR \
  \$ANSI_DISPLAY_FG_$PS1_HOSTNAME_FG \
  \$ANSI_DISPLAY_BG_$PS1_HOSTNAME_BG
  ")\\h"
PS1_COLON="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE):"
PS1_PWD="$(ansi_display_sequence_ps1)\\w"
PS1_END="$(ansi_display_sequence_ps1 $ANSI_DISPLAY_ATTR_BRIGHT $ANSI_DISPLAY_FG_WHITE)\\\$"
if [ -n "$PS1" ]
then
  PS1="${PS1_STATUS}${PS1_USER}${PS1_AT}${PS1_HOSTNAME}${PS1_COLON}${PS1_PWD}${PS1_END}$(ansi_display_sequence_ps1) "
fi
