#!/bin/bash

################################################################################

_fileinfo="
#==============================================================================#
# File Header Info     
#-------------------------------------------------------------------------------
# FILEINFO=(                     
#  FILENAME: 'runbatch__ .sh'
#  author:   'Daniel.Collins' 'DAC' 'Daniel.Collins@enervenue.com'  
# );
# VERSIONING=(
#  '2022-1021-1500'
#  '2022-1024-1800'
#  '2022-1025-0907
'
# );
#
#==============================================================================#"
_usage="
 runbatch.sh b {BWD} c {FNP} f {FIN} l {LSB}
  - FNP: number of processors for computing <def:38 >
  - BWD: base work-directory <def: PWD:$PWD>
  - FIN: (file) list of case directories to run in batch
  - LSB: (list array declared in bash): list of case directory to run in batch
"
#==============================================================================#
DEF_BWD=$PWD ;
DEF_FNP=38 ;

#-------------------------------------------------------------------------------
BWD=$DEF_BWD;
BWD=/data/es200cpv/PH1b ;
setbats=(
    x22b_cont 
    y22b_cont 
    z22b_cont
);
BWD=/data/escpv/ph2_stagger;
setbats=(
y22stag-v5.00-u1.00
y22stag-v5.00-u2.00
y22stag-v2.50-u1.00
);
#y22stag-v2.50-u2.00

bats=$setbats;
#==============================================================================#
##=========================================================
while [[ ${#@} -gt 0 ]] ; do ## INPUT ARGUMENTS AS OPTIONS 
	key="${1}"
	case "$key" in 
	 b) shift; BWD=$1 ;;
   c) shift; FNP=$1 ;;
	 f) shift; INF=$1 ; bats=(`cat $INF`) ;;
	 l) shift; LSB=$1 ; bats=${LSB[@]}    ;;
  esac ;
  shift;
done;
if [ -z $BWD  ] ; then BWD=$DEF_BWD; fi ;
if [ -z $FNP  ] ; then FNP=$DEF_FNP; fi ;
if [ -z $bats ] ; then bats=$setbats; fi ;

##=========================================================
#==============================================================================#

 alias tailrun=' xterm -title "TAILING CASE : $(ls -tr *sim|tail -n1 )" -geom 480x40 -e tail --retry -n 1000 -f -F $(ls -tr *run.log) & ';
 alias lmss='    lmutil lmstat -a -c /home/common/lic/starlicense.dat \
  							| grep -e "Users of ccmppower:" -A 6 \
  							| grep -v server_id \
							  | grep -e ":" ' ;
 function runloop()
 {
  for c in ${bats[@]} ;
  do
    swd=$BWD/$c ;
    printf "next case to run in ${swd} " ;
    cd $swd ;
    ls -latr ;
    ( lmss ) ;
    ( date ) ;
    printf "now runnning simulation for %s"  $(ls -tr *.sim | tail -n1) ;
    lastsim=$(ls -tr *sim|tail -n1 ) ;
    simcase=${lastsim%%.sim} ; 
    xterm -title "TAILING CASE : $(ls -tr *sim|tail -n1 )" \
          -geom 480x40 \
          -e tail --retry -n 1000 -f -F $(ls -tr *run.log) &

    runsim.sh $FNP ;

  done ; ###EO for c in ${bats[@]} 
  cd $BWD ;
 }

 ( runloop )

