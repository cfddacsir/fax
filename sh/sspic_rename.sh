#!/bin/bash

## sspic_rename.sh
## Daniel.Collins /2022-10-08.
## automatically rename files that are in HOME/Pictures:
##  "Screenshoot from YYYY-MM-DD HH-MM-SS.png" ->
##  "SSPIC--YYYY-MM-DD-HH-mm-ss.png" 

PICHOME=$HOME/Pictures ;
cd $PICHOME ;

WC=$(find . $PICHOME | grep "Screenshot" | wc -l ) ;
#printf " there are $WC number of instances of Screenshot ";

function rent(){
  FF=$(find . $PICHOME | grep "Screenshot" | tail -n 1) ;
	ls -la "$FF" ;
	FA=$(printf "$FF" | awk '{print $3}' ) ;
	FB=$(printf "$FF" | awk '{print $4}' ) ;
  FP=$(printf "$FF" | awk -F 'Screenshot' '{print $1}' ) ;
	FNEW="SSPIC--YYYY-MM-DD-HH-mm-ss.png" ;
	FNEW="${FP}SSPIC--${FA}-${FB}" ;
	printf "\nrenaming %s to %s " "$FF" "$FNEW" ;
  X=$(printf "mv -v \"%s\" \"%s\" " "$FF" "$FNEW" );
  printf "\n";
  printf "%s\n" "$X" ;
  eval $X ;
#	WC=$(find . | grep "Screenshot" | wc -l ) ;
#  printf "\n there are $WC number of instances of Screenshot ";

}
#while [ $WC -gt 1 ]; do
#printf "\n there are $WC number of instances of Screenshot \n";
for q in `seq 0 $WC`; do
  ( rent ) 
	WC=$(find . | grep "Screenshot" | wc -l ) ;
  printf "\n there are $WC number of instances of Screenshot \n";
  if [ $WC -eq 0 ]; then break; fi
done;
printf "\n";
