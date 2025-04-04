#!/bin/bash

################################################################################
_fileinfo="
#===============================================================================
 FILENAME: bsubmit.sh
 AUTHOR:   Daniel Collins, <Daniel.Collins@enervenue.com> [DAC]

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
 2022-1105-1500t 2022-1106-0700u 2022-1107-1019u 2022-1108-1418u 2022-1109-1033u 
 2022-1110-1046u 2022-1110-2117u 2022-1111-1210u 2022-1111-2100u
 2022-1115-1400u 2022-1116-0555u 2022-1116-0605u 2022-1116-1755u 
 2022-1205-1045u 2023-0205-1918u
);_rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;

#==============================================================================#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
BATEXEOPTS=" -o s "  ; ### run-solver  for CASEDIRS
BATEXEOPTS=" -o p "  ; ### post-solver for CASEDIRS
BATEXEOPTS=" -o p -i /home/dac/JOBS/case.cfg  -b /data/escpv/etw3_hvac/meshval -c " ; 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#==============================================================================#
  unset cmdhelp; unset here ; unset _here; here=$(pwd) ; _here=$(pwd) ;

  unset BATS blog BATEXEOPTS JOBN bk bkhelp ;
  here=$PWD; 
  DEF_JOBFSH=starbatch.sh ; 
  DEF_JAVAMACRO="/home/dac/starmac/proj_escpv/escpv_post.java" ;
  JOBFSH=$DEF_JOBFSH ;
  JAVAMACRO=$DEF_JAVAMACRO ;
  function snow()  { printf "%s" $(date +%s); };
  function snowe() { NOW=$(date +%s);  printf $NOW;  };

#==============================================================================#
_usage=" 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 bsubmit.sh -b {JOBFSH} -jm {JAVAMACRO} -x {BATEXEOPTS} 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 -b  {JOBFSH} : <file> jobscript to be executed
      (def: /home/dac/JOBS/JSUB/starbatch.sh )
 -jm {JAVAMACRO}: <file> star macro to be executed for starccm eg postprocessing
      (def: /home/dac/starmac/proj_escpv/escpv_post.java )
 -x  {BATEXEOPTS}: <\string\>
      (ex:  \-o gif -f /home/dac/JOBS/CASECONF/case.conf\ )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2); } 
showrev(){ 
      printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ;
}

#==============================================================================#
	function jobctr() { #~~~
	  cjob="$HOME/JOBS/JCTR" ;
	  npjobs=$( ls -tA ${cjob} | wc -l ) ; 

    xjob=$((  npjobs + 1))
	  vjob=$( ls -tA ${cjob}|head -n1) ; 

	  if [ ${xjob} -lt 1 ];       then QJOB="0000${xjob}"; else
	   if [ ${xjob} -lt 10 ];      then QJOB="000${xjob}"; else
	    if [ ${xjob} -lt 100 ];     then QJOB="00${xjob}"; else
	     if [ ${xjob} -lt 1000 ];    then QJOB="0${xjob}";
	     fi 
	    fi 
	   fi
	  fi
	  TJOB="${cjob}/${QJOB}" ;
	  touch ${cjob}/${QJOB}  ;
    printf "%s" "${QJOB}" ;
  } #~~~ ~~~#
#==============================================================================#

function launchvore() { #~~~
  bjob="${HOME}/JOBS" ;
  cjob="${HOME}/JOBS/JCTR" ;
  wjob="${HOME}/JOBS/JLOG" ;
  ##ujob="${HOME}/JOBS/JSUB" ;
  ujob="${HOME}/JOBS/" ;

  mkdir -p  ${bjob} ;mkdir -p  ${cjob} ;mkdir -p  ${wjob} ;mkdir -p  ${ujob} ;

  JOBN=$(jobctr ) ;
  BATS="${ujob}/${JOBFSH}";
  blog="${wjob}/ejob_${JOBN}.log"; 
  printf ' ' >${blog};

} #~~~ ~~~#
###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>###
function exes() { #~~~
  #( launchvore );
  bjob="${HOME}/JOBS" ; 
  cjob="${HOME}/JOBS/JCTR" ;
  wjob="${HOME}/JOBS/JLOG" ;
  ### ujob="${HOME}/JOBS/JSUB" ;
  ujob="${HOME}/JOBS/" ;
  mkdir -p  ${bjob} ;mkdir -p  ${cjob} ;mkdir -p  ${wjob} ;mkdir -p  ${ujob} ;
  JOBN=$(jobctr ) ;
  BATS="${ujob}/${JOBFSH}";
  blog="${wjob}/ejob_${JOBN}.log"; 
  ### export blog ;
  printf ' ' >${blog};
  ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  printf "
################################################################################
   $(date    +%Y%m%d-%H%M%S )
   $(date -u +%s )
   $bjob 
   $cjob
   $wjob
   $ujob 
   JOBNUMBER:   ${JOBN} 
   JOBDIR:      ${bjob} 
   source:      ${BATS}             
   blog:        ${blog}           
   BATEXEOPTS:  ${BATEXEOPTS} 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n
  " | tee -a ${blog} ; 
  ## cat bsubmit.sh | tee -a ${blog} ;
  printf "
xterm   -geom  120x100 \
         -title \"RUNNING JOB#${JOBN} Log: ${blog}\" \
         -hold  \
         -e     \"${BATS} ${BATEXEOPTS} | tee -a ${blog} \" 
################################################################################
\n" | tee -a ${blog} ;

  xterm  -geom  120x100 \
         -title "RUNNING JOB#${JOBN} Log: ${blog}" \
         -e     "${BATS} ${BATEXEOPTS} | tee -a ${blog} ; sleep 1m " 

} #~~~ ~~~#
###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Argumentsf
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  while [[ ${#@} -gt 0 ]] ; do 
	  key="${1}"
	  case "$key" in 
 	   -b ) shift; JOBFSH=$1 ;
          if [ -z ${JOBFSH} ]; then 
          JOBFSH=${DEF_JOBFSH};
          fi
     ;;
 	   -jm) shift; JAVAMACRO="${1}" ;
          if [ -z ${JAVAMACRO} ]; then 
          JAVAMACRO=${DEF_JAVAMACRO};
          fi
     ;;
 	   -x ) shift; BATEXEOPTS="${1}" ;  
          printf "BATEXEOPTS = %s" "${BATEXEOPTS}" 
     ;;
 	   -h|--h|--help) cmdhelp="h"; break
     ;;
    esac 
   shift
  done;
  if [[ "${cmdhelp}" == "h" ]] ; then
     printf "${_usage}"; (showrev) ;
  else 
     ( exes ) ;
  fi 
##============================================================================##
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%d-%H%M) \n" ;
printf " \f \n";
unset cmdhelp; unset here ; unset _here; here=$(pwd) ; _here=$(pwd) ;
##============================================================================##

################################################################################
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
#                             #[[ END OF SCRIPT ]]#                            #
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
################################################################################
