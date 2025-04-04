#!/bin/bash

################################################################################
FILENAME=$(basename $0);
#===============================================================================
FILEINFO=( 
    $FILENAME
    'atop.sh' 
    'Daniel.Collins'
);
VERSIONING=(
	  '2022-08-12-1726-T'
);
HUB='/home/common/sh' ;
CLIB='/home/common/clib' ;
      sh_runsim="${HUB}/atop.sh" ;
alias runsim=" . ${HUB}/atop.sh" ;

#===============================================================================
bu=$(pfs '__' 40)
br=$(pfs '==' 40)

aloo=$HOME/atop.log
floo=$HOME/freetop.log 

function loo(){
	loo=$( ls -tr *.log*| tail -n 1 );
  printf $( ls -tr *.log*| tail -n 1 );
}

function dloo(){
	dloo=$( ls -tr *.log*| tail -n 1 );
  printf $(ls -tr $(find /data/ | grep -e '.log' ) | tail -n 1);	
}

##---------------------------------------------------------

function pfs () { 
  OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT;
	};


show_free(){
	printf "%s \n" $(pfs '__' 40)
   date 
	free -h 
	printf "%s \n" $(pfs '--' 40)
}

show_date(){
	printf "%s \n" $(pfs '__' 40)
   date 
	printf "%s \n" $(pfs '--' 40)
}

show_top(){
	printf "%s \n" $(pfs '__' 40)
   date 
  top -b -n 1 | head -n 20 
	printf "%s \n" $(pfs '--' 40)
}

fine(){
	printf "%s \n" $(pfs '__' 40)
}

##---------------------------------------------------------
## OPTIONS
while [[ ${#@} -gt 0 ]] ; do
	key="${1}"
	case "$key" in 
   f)
 		show_free >> $floo ;
		tail -n 10   $floo;
   ;;
	 v) 
 		show_free >> $floo 
		show_free >> $(loo)
		tail -n 10   $floo;
   ;;
	 s) 
 		show_free >> $floo 
		show_free >> $(dloo)
		tail -n 10   $floo;
   ;;
   w) 
    show_free | tee -a $aloo
   ;;
   d)
    show_date | tee -a $aloo
   ;;
   e)
    show_date >> $(floo) 
   ;;
   t)
    show_top  | tee -a $aloo 
   ;;

   za)
    fine >> $aloo
   ;;
   zf)
    fine >> $floo
   ;;
  esac;
  shift;
done

##=======================================================##

