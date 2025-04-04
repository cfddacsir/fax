#!/bin/bash
#==============================================================================#
# File Header Info
#-------------------------------------------------------------------------------
FILENAME=$(basename $0); 
FILEINFO=( 
  $(basename $0)
  'backup.sh'
  'Daniel.Collins' 'DAC' 'Daniel.Collins@enervenue.com'
);
VERSIONING=(
  '2022-06-29-2200-T'
  '2022-06-30-1200-T'
);
##============================================================================@@
startingcwd=$PWD
#==========================================================
# default values
	lo="$HOME/backup.log"
	asrc="$PWD"
	bdest="/ware1a/"

##=========================================================
#  prompting selections
sel_arsc(){
printf "
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Choose path being archived.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 0  ) current pwd, ${PWD}, *default 
 11 ) /etc/*

 20 ) my home $HOME
 21 ) /home/*ALL
 22 ) /home/common/*

 30 ) /data/

 50 ) prompt list from favorite paths in .pathrc
 88 ) define other 
 99 ) ~Abort~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
read -p "> :" sel
case "$sel" in
 30)   asrc="/data/"
 ;;
 20)   asrc="$HOME/"
 ;;
 21)   asrc="/home/"
 ;;
 22)   asrc="/home/common/"
 ;;
 11)   asrc="/etc"
 ;;
 99 )  asrc=ABORT; exit
 ;;
 0|*)  asrc=$PWD 
 ;;
esac
}
sel_bdest(){
printf " 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
choose the location to store the backup:
 1  = /data1b/
 2  = /ware1a/
 3  = mounted-usb
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 99 = ~Abort~ 
"
read -p "> :" sel
case "$sel" in
 1 )   bdest="/data/"
 ;;
 2 )   bdest="/ware1a/"
 ;;
 3 )   # need to create method for finding mounted usb-disks
       bdest=""
 ;;
 99)   bdest=ABORT; exit 
 ;;
esac
}
sel_bau(){
printf " 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Do you wish to add more ?
 1  = Yes
 0  = No
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
read -p "> :" sel
case "$sel" in
 1 )   bau=1
 ;;
 2 )   bau=0
 ;;
esac
export bau
}

sel_ract(){
printf " 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 do as actual rsync or as dry-run
 1  = Yes, actual rsync
 0  = No,  dry-run only
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
read -p "> :" sel
case "$sel" in
 1 )   ract=1
 ;;
 2 )   ract=0
 ;;
esac
ract=$sel
}

build_selection(){
while [ $build_a -gt 0 ]; do
	sel_bau
  sel_arsc
  echo 1  
done

while [ $build_b -gt 0 ]; do
  sel_bau
  sel_bdest
  echo 1  
done

}

##=========================================================

 sel_arsc  ;
 sel_bdest ;
 sel_ract  ;

##=========================================================
cd $asrc
printf "
  archiving $arsc to $bdest  ..................
"

for z in ${bdest[@]}
do
  a=${asrc}
  b=$(basename $a)
  c=${a%%$b}
  zz=$z/$c
  mkdir -pv $zz

	case $ract in 
		1) 
	#	if [ $ract=="1" ]; then
	#### act run
				 diruse.sh $zz
				 rsync -vr -t -W  $asrc $zz  >> $lo
				 diruse.sh $zz
	#	fi
		;;
		0|*)
	#### dry run
			 rsync -vr -t -W -n $asrc $zz
		;;
  esac 
  cd $zz
  pwd
  ls -la1 $PWD/.
done
if [ $ract==1 ]; then tail -n 10 $lo ; fi
##=========================================================
## returning to original cwd
cd $startingcwd
################################################################################

