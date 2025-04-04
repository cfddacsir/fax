#!/bin/bash
################################################################################
_info=" ========================================================================
# FILENAME: {NEUE}.sh
# AUTHOR:   Daniel Alan Collins (DAC) <Daniel.Collins@enervenue.com>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
 2023-0106-1217 
); _rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;
################################################################################

#==============================================================================#
_usage=" 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 bsubmit.sh -x {BATEXEOPTS} 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 -x  {BATEXEOPTS}: <\string\>
      (ex:  \-o gif -f /home/dac/JOBS/CASECONF/case.conf\ )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2) ; } 
pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;};
pss() { printf "%s\n" $(pfs $1 $2 ) ; } 
showrev(){ printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ; };
PARA=$(pp \= 60) ;
pdiv(){ printf "\n$PARA\n" ; } 
PDIV=$( printf "\n%s\n" $(pp \= 60) );

#==============================================================================#

################################################################################
exes() { #~~~
  printf "\n$PARA\n 
  \tPARAMETER: ${PARAMETER} 
  " ; printf "\n$PARA\n";
  
  for thiscase in ${CASEDIRS[@]} ;
  do
    printf "%s \n" $( date +%s ) ;
  done; ###///EO for thiscase in ${CASEDIRS[@]} ///###

} #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  while [[ ${#@} -gt 0 ]] ; do 
	  key="${1}"
	  case "$key" in 
 	   -C ) shift; CLOUD=${1}; 
          if [ -z ${CLOUD}]; then CLOUD=${DEF_CLOUD}; fi
          printf "CLOUD="; printf "%s\t" ${CLOUD}
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

###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
printf "\f \t ${cmdhelp} \n"; unset cmdhelp;
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%d-%H%M) \n" ;
printf "\f \n";
cd $here ;  unset here ;
################################################################################
