#!/bin/bash
##===========================================================================##
##          bmscsv_counter.sh
## author:  Daniel Collins
## created: 2022-10-13-S-0910
## revised:
_usage="
  csv_counter.sh : counts the number of BMS csv files for each date 
";
##===========================================================================##

##===========================================================================##

$C="$PWD" ;


alias seek='find . $PWD|grep' ;
of="./bmscounter.txt" ;
yyyy=2022;
bkey="ES-720" ;
##===========================================================================##
base=""
##===========================================================================##
function dcount(){
	printf "Counting number of BMS files for each date for $PWD \n";
	for m in `seq 9 10`; do
		mm=$m; if [ $m -lt 10 ] ; then mm="0$m"; fi ;
		
		for d in `seq 1 31`; do
		dd=$d; if [ $d -lt 10 ] ; then dd="0$d"; fi ;

		# csvct=$(find . $C | grep -e "$yyyy-$mm-$dd" | grep -e "$bkey" | wc -l )
#		csvct=$(find .      | grep -e "$yyyy-$mm-$dd" | grep -e "$bkey" | grep -ve './' | wc -l );
		csvct=$(find .      | grep -e "$yyyy-$mm-$dd" | grep -e "$bkey" | wc -l );
#    csvct=$(echo "$csvt / 2 " | bc -l );
		printf '%s : %d \n' "$yyyy-$mm-$dd" $csvct ;

		done

	done
}
  printf '' > $of
( dcount ) | tee -a $of
##===========================================================================##

##=========================================================
while [[ ${#@} -gt 0 ]] ; do ## INPUT ARGUMENTS AS OPTIONS 
	key="${1}"
	case "$key" in 
   a)
 		shift;
    VAL=$1 
   ;;
	 b) 
 		shift;
    VAL=$1 
   ;;
	 c) 
    VAL=1000
   ;;
  esac;
  shift;
done
##=========================================================

