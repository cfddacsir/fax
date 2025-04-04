#!/bin/bash
###########################################################

##  FILEINFO >============================================
FILEINFO=(
    'setnickel'
    'setnickel.sh'
    'Daniel.Collins'
    'DAC'
    2022 02 14 1443 T
    );

###--------------------------------------------------------
#	DASH='~dac/sh'
#	MYSH="$HOME/sh"
export  HUB='/home/common/sh'
export  DASH=$HUB
export  MYSH="$HOME/sh/"
      	setnickel="$DASH/setnickel.sh"
alias 	setnickel=" . $setnickel; printf \"loading %s\n \" $setnickel "

###========================================================

##---------------------------------------------------------
## Ubuntu 
   alias aptc='apt-cache search $1  '
   alias apti='sudo apt-get install -y $1'
##---------------------------------------------------------


##---------------------------------------------------------
   alias setstar=". $DASH/setstar.sh"
#   . $DASH/setstar.sh  ## initializing star configurations
##---------------------------------------------------------
   alias bxdividers=". $DASH/bxdividers.sh"
#   . $DASH/bxdividers.sh
##---------------------------------------------------------
   alias setcomsol=". $DASH/setcomsol.sh"
#   . $DASH/setcomsol.sh
##---------------------------------------------------------


##---------------------------------------------------------

  qstar='/home/common/lib/qstar.py'
  alias qstar=" $qstar $1 "

###########################################################
