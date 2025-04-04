#!/bin/bash

###<  SHEADER  >===========================================
 SVIN=(netcheck.sh 1433 08 09 2020 U-0700);
 SVKN=('Daniel_A_Collins' 'DAC' 'dacdynamics@gmail.com');
 NOW=$(date +%Y%m%d%-H%M%S);
 BDIV1="##=========================================================";
 BDIV2="##=======================================================##";
 BDIV3="##---------------------------------------------------------";
###========================================================

###< f:prheader  >==============================================
 function PRHEADER() {
  BDIV2="##======================================================="
  SHEADER="${BDIV2} \n\
# FILE: ${SVIN[0]} \n\
# VERS: ${SVIN[1]}.${SVIN[2]}.${SVIN[3]}.${SVIN[4]} / ${SVIN[5]} \n\
# AUTH: ${SVKN[0]} / ${SVKN[1]} / <${SVKN[2]}> \n${BDIV2}\n";
  export SHEADER;
  [[ -n $PH ]] && (printf "\fHeader:\f $SHEADER\f " );
 } ###-<END: function PRHEADER
###########################################################

unset DOLE key;
###< f:getargs >===========================================
function getargs() {
  ## GETTING ARGUMENTS
  while [[ $# -gt 0 ]] ; do
    key="${1}"
     case $key in
      -v|-V)  PH=1;;
       -of)   DOLE="1"  ;;
     esac
    shift
  done;
  if [ -z $af ]; then getf; fi
  if [ -z $os ]; then os=$def_os; fi
###########################################################

###<  PARAMS  >============================================
  _THOSTS=(192.168.0.1 speedtest.xfinity.com www.scu.edu);
  _THOSTS=(192.168.0.1 192.168.1.1 speedtest.xfinity.com www.time.org);
  LEO=~/$NOW.log;
  pdiv1='##======================================';
  pdiv2='--------- --------- --------- --------- ';

##===================================================================##
  function hts() {
    hx=$1;
    printf "${pdiv1}\n";
    printf "${pdiv2}\n : pinging    to ${hx} \n";
    ping -c 5                $hx ;
    printf "${pdiv2}\n : traceroute to ${hx} \n";
    printf "traceroute ....  $hx";
    traceroute -m 15 -S      $hx ;
  } ##//EO function hts
  printf "${pdiv1}\n"
  date +%Y-%m-%d--%H%M-%S
  printf "
  Shall test connection to the hosts in the list....";
    printf "host: %s" ${_THOSTS[@]};
  printf "${pdiv1}\n"
  for hx in ${_THOSTS[@]}; do
    if [[ -n ${DOLE}  ]] ; then
	hts "$hx" >> $LEO; else
	hts "$hx"      ;
    fi
  done
  printf "
  Now showing the log in testing connection to the hosts in the list....";
    printf "host: %s" ${_THOSTS[@]};
  cat $LEO;

###########################################################
### ENDING  >==============================================
if [[ -n $PH ]] ; then (PRHEADER); printf "$SHEADER";fi;
echo -e "\n${SVIN[0]}.\n** DONE $(date +%Y%m%d@%H:%M:%S).";
###<<<ENDOFSCRIPT=====================================<<<<<
###########################################################
