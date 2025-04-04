#!/bin/bash
###########################################################
##=========================================================
FILEINFO=( 
    'diruse.sh' 
    'Daniel.Collins'
    );
VERSIONING=(
    '2022-04-30-1056-T'
    '2022-03-27-1409-T'
    '2022-03-08-1228-U'
    );
	HUB='/home/common/sh' ;
      	diruse="${HUB}/diruse.sh" ;
  alias diruse=". ${HUB}/diruse.sh";
## defaults ---
  DIRUSE_DEF='/data/'; ## default value for {DIRUSE}
  DIRUSE_DEF=$(pwd) ; ## default value for {DIRUSE}
  DIRLOGS='/home/common/logs'
##=========================================================
usage=" diruse.sh {ARG:1} 
  {DIRUSE} = { ARG:1 | *default } 
     /* default: DIRUSE_DEF : ${DIRUSE_DEF} /
  /directory consumption of {DIRUSE} will be logged 
     in DIRLOGS: ${DIRLOGS} 
";
##=========================================================
## Paragraph Breaks
   function prab() {
      OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); 
			printf '%s' $OUT ;
   }
   #echo "ha"
   SECTBRK=$(printf "%s \n" $(prab '=' 60) )
   SUBSBRK=$(printf "%s \n" $(prab '-' 60) )
   PARABRK=$(printf "%s \n" $(prab '-' 60) )
   #echo "ha"		   
#==========================================================

##=========================================================
## PARAMETERS --------------------------------------------
if [ $1 ] ; then DIRUSE=${1}; else DIRUSE=${DIRUSE_DEF}; fi
DIRUSESTR=$( printf "%s" $DIRUSE | sed "s/\//--/g")
mkdir -p -m=775 $DIRLOGS
NOW=$(date +%Y-%m%d-%H%M)
lo=${DIRLOGS}/diruse_PWD.${DIRUSESTR}._REC.${NOW}.log

printf "\n 
  DIRUSE    = $DIRUSE
  DIRUSESTR = $DIRUSESTR 
  DIRLOGS   = $DIRLOGS
  NOW       = $NOW
  lo        = $lo
"

cd ${DIRUSE}
cat > $lo <<EOF
$SECTBRK
  DIRUSE    = $DIRUSE
  DIRUSESTR = $DIRUSESTR 
  DIRLOGS   = $DIRLOGS
  NOW       = $NOW
  lo        = $lo
$PARABRK

$SECTBRK
  CONTENTS OF DIR: $DIRUSE
  recorded on $(date)
  being recorded in $lo
$PARABRK

$SECTBRK
  disk usage where DIR resides << df . >> 
$PARABRK -->
$(df -ah .)
$(df -a  .)


$SECTBRK
<< du -cah -d 1 ${DIRUSE} 
$PARABRK>>
$( du -cah -d 1 ${DIRUSE})

$SECTBRK
<< ls -l -h -1 -A -tr -R ${DIRUSE}
$PARABRK>>
$( ls -l -h -1 -A -tr -R ${DIRUSE} )

$SECTBRK
<< ls -lAtrh $( find ${DIRUSE} | grep sim )
$PARABRK>>
$( ls -lAtrh $( find ${DIRUSE} | grep sim ))
$SECTBRK
<< du -cah   $( find ${DIRUSE} | grep sim )
$PARABRK>>
$( du -cah   $( find ${DIRUSE} | grep sim ))


$SECTBRK
$( date)
$PARABRK
$SECTBRK

EOF

##=======================================================##

###########################################################


