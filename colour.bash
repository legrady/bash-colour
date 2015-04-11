#!/bin/bash

# <ESC>[{attr};{fg};{bg}m
# {attr} is one of following
#
#	0	Reset All Attributes (return to normal mode)
#	1	Bright (Usually turns on BOLD)
#	2 	Dim
#	3	Underline
#	5	Blink
#	7 	Reverse
#	8	Hidden
#
#{fg} is one of the following
#	30	Black		31	Red	32	Green
#	33	Yellow		34	Blue	35	Magenta
#	36	Cyan		37	White
#
#{bg} is one of the following
#	40	Black		41	Red	42	Green
#	43	Yellow		44	Blue	45	Magenta
#	45	Cyan		47	White
#

function encode_attr {
#    echo "encode_attr invoked with args $*";
    ATTR='';
    case "$1" in 
    'NORMAL')     ATTR=0 ;;
    'BRIGHT')     ATTR=1 ;;
    'BOLD')       ATTR=1 ;;
    'DIM')        ATTR=2 ;;
    'ITALIC')     ATTR=3 ;;
    'UNDERLINE')  ATTR=4 ;;
    'BLINK')      ATTR=5 ;;
    'DUNNO')      ATTR=6 ;;    
    'REVERSE')    ATTR=7 ;;
    'HIDDEN')     ATTR=8 ;;
    *)
       echo "\[\e[5:31m \]Unkown arg to encode_attr(): $1 \[\e[00m\]";
       ;;
    esac
#    echo "encode_attr has set ATTR to $ATTR."
}

function encode_color {
#    echo "encode_color invoked with args $*";    
    COLOR=''
    case "$1" in
    'BLACK')   COLOR=30 ;;
    'RED')     COLOR=31 ;;
    'GREEN')   COLOR=32 ;;
    'YELLOW')  COLOR=33 ;;
    'BLUE')    COLOR=34 ;;
    'MAGENTA') COLOR=35 ;;
    'CYAN')    COLOR=36 ;;
    'WHITE')   COLOR=37 ;;
    *)
       echo "\[\e[5:31m \]Unkown arg to encode_color(): $1 \[\e[00m\]";
       ;;
    esac
#    echo "encode_color has set COLOR to $COLOR."    
}

function encode_fg {
#    echo "encode_fg invoked with args $*";    
    encode_color "$1";  
    FG=$COLOR;
#    echo "FG set to $FG"
}

function encode_bg {
#    echo "encode_bg invoked with args $*";
    encode_color "$1";  
    (( BG = COLOR + 10 ));
#    echo "BG set to $BG"
}
   

function ANSI_color {
#    echo "color invoked with args $*";    
   ATTR='';
   FG='';
   BG='';
   if [[ $# -gt 3 ]]; then	# Handle too many args
       echo "\[\e[5:31m \]Too many args to color(): $* \[\e[00m\]";
       exit;
   fi
   if [[ $# == 0 ]]; then	# Handle no args => 'normal' code
       ANSI_SEQUENCE="\e[00m]"
       return
   fi
   if [[ $# == 3 ]]; then	# Handle optional attribute
       local attr=$1;
       shift
       encode_attr "$attr"; 
       ATTR="$ATTR;";		# add semicolon
   fi
   if [[ $# == 2 ]]; then	# single arg is fg, bg is optional
       encode_fg "$1";
       FG="$FG;";		# add semicolon
       encode_bg "$2"; 
   else
       encode_fg "$1"; 
   fi
#   echo "in ANSI_color, ATTR=$ATTR, FG=$FG, BG=$BG, COLOR=$COLOR"
   ANSI_SEQUENCE="\e[${ATTR}${FG}${BG}m";
#   echo "$ANSI_SEQUENCE test \[\e[00m\]"
   return
}

function hide_escape {
    if [[ -n $ANSI_SEQUENCE ]]; then
	ANSI_SEQUENCE="\[${ANSI_SEQUENCE}\]"
    fi
}

# (c) April, 2015 Tom Legrady <Tom@TomLegrady.com>
#
# Released under
#   Artistic License (http://dev.perl.org/licenses/artistic.html)
#   GNU Lublic License v3 (http://www.gnu.org/licenses/).
# Use it, just don't claim you wrote it.

# END OF FILE --------------------------------------------------
