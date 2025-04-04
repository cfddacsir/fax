#!/bin/bash


################################################################################
_fileinfo="
#==============================================================================#
# File Header Info
#-------------------------------------------------------------------------------
 FILENAME: 'bashrx.sh'                          #  FILENAME=$(basename $0)  #
 AUTHOR:   'Daniel.Collins' 'DAC' 'Daniel.Collins@enervenue.com'  
 
 VERSIONING=(
   '2022-0815-1150t' '2022-1004-0920t' '2022-1012-0816t' '2022-1013-1123t'
   '2022-1025-0855t'
 );
#==============================================================================#"

# =========================================================
# INPUT ARGUMENTS AND WHILE CASE
# --------------------------------------------------------
  while [[ ${#@} -gt 0 ]];do ### GET INPUT ARGUMENTS/OPTIONS
	  key="${1}"
	  case "$key" in 
     a)	shift;  VAL=$1  ;;
	   b) shift;  VAL=$1  ;;
	   c)         VAL=1000  ;;
    esac;
    shift;
  done; 
  if [ -z $VAL ] ; then VAL=$DEF_VAL; fi ;

##=========================================================

# =========================================================
#  Main
# --------------------------------------------------------

	if [ $DO1 -eq 1 ] ; then 
		( function_1 ); 
	else 
		[ $DO2 -eq 1 ] && ( function_2 ) ;
	fi;

##=========================================================

  function lalo() {
     lalo=$(ls -tr *.log*|ta1); printf $lalo;
	};
  function pp(){ printf "$1%.s" $(seq 1 $2) ; }
  PRBR=$(pp '=' 60 );
  function pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;};
  DIVI=( 
		$(pfs '##' 30)
		$(pfs '==' 30)
		$(pfs '--' 30)
		$(pfs '..' 30)
		$(pfs '__' 30)
		$(pfs '~~' 30)
		$(pfs '//' 30)
  ); 
  function baba(){ printf "%s\n" "${DIVI[1]}" | tee -a ${1} ; }
  function daba(){ printf "%s\n" "${DIVI[3]}" | tee -a ${1} ; }

##=========================================================
##---------------------------------------------------------
##	TIMESTAMPING
##---------------------------------------------------------
  fav_timestyle="--time-style='+%Y%m%d-%H%M'" ;
  NOW=$(date +%Y%m%d%-H%M%S);
  TICK=$(date +%Y%m%d-%H:%M:%S); 
  function tic() { TIC=$(date +%s ); printf "%s" "${TIC}" ; }
  function jnow(){ printf "%s" $(date +%Y%m%d_%H%M%S         ); };
  function unow(){ printf "%s" $(date +%Y%m%d_%H%M%S -u      ); };
  function enow(){ printf "%s" $(date +%s            -u      ); };

  function jnow(){ NOW=$(date +%Y%m%d_%H%M%S); printf $NOW;  };
  function unow(){ NOW=$(date +%Y%m%d_%H%M%S -u); printf $NOW;  };
  function enow(){ NOW=$(date +%s -u); printf $NOW; };

  function lazt(){ 
    printf $(ls -la --time-style='+%Y%m%d-%H%M' ${1} |awk '{print $6}'); 
  };
	alias cpz=' cp -vu  --no-preserve=timestamps '
	alias cpt=' cp -vf     --preserve=timestamps '

##=========================================================

################################################################################

