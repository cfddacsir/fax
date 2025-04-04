#!/bin/bash
################################################################################
_info=" ========================================================================
 FILENAME: {NEUE}.sh
 AUTHOR:   Daniel Alan Collins (DAC) <Daniel.Collins@enervenue.com>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
 2023-0106-1217u 
); _rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;
################################################################################
DEF_CLOUD="${HOME}/onedrive/NICKEL/home";
DEF_LOCAL=(
~/Documents
~/Desktop
~/Pictures
~/starmac
~/JOBS
~/loo
~/BANK
~/tools
~/
);
#==============================================================================#
_usage=" 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 onetax.sh -L {File} -C {Str}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 -L  <File> file listing directories/paths to be synched
 -C  <Str>  path for cloud repository, def: ${DEF_CLOUD}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2) ; } 
pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;};
pss() { printf "%s\n" $(pfs $1 $2 ) ; } 
showrev(){ printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ; };
PARA=$(pp \= 60) ;
pdiv(){ printf "\n$PARA\n" ; } 
PDIV=$( printf "\n%s\n" $(pp \= 60) );

#==============================================================================#
#==============================================================================#
### mounting onedrive with rclone, dest = ~/onedrive \\ ${SETONE}
mount_onedrive(){
  SETONE="${HOME}/onedrive";
  # if [ ! -f ${SETONE} ] ; then 
    mkdir -pv -m=777 ${SETONE}
    chmod -R 777 ~/onedrive ;
    ls -latr ${SETONE} ;
  # fi
  rclone mount --vfs-cache-mode writes "onedrive:" ${SETONE} &
  sleep 3s;
  ls -latr ${SETONE} | head -n 10 ;
}


################################################################################
exes() { #~~~
  if [ -z ${CLOUD}]; then CLOUD=${DEF_CLOUD}; fi
      printf "CLOUD="; printf "%s,\t" ${CLOUD}
          if [ -z ${LOCAL}]; then LOCAL=${DEF_LOCAL[@]}; fi
      printf "LOCAL="; printf "%s,\t, " ${LOCAL[@]}
  
  if [ !-f ${CLOUD} ]; then 
    ( mount_onedrive ) ;
  fi
#   ( mount_onedrive ) ;

  printf "\n$PARA\n 
  \tPARAMETER: ${PARAMETER} 
  " ; printf "\n$PARA\n";
  
  printf "%s \n" $( date +%s ) ;
  for eachdir in ${LOCAL[@]} ;
  do
    printf "\n\t Syncing rsync from $eachdir onto ${CLOUD} ...." ;
    rsync -avzr ${eachdir} ${CLOUD} ;
    
  done; ###///EO for thiscase in ${CASEDIRS[@]} ///###

} #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  while [[ ${#@} -gt 0 ]] ; do 
	  key="${1}"
	  case "$key" in 
 	   -x ) shift; BATEXEOPTS="${1}" ;  
          printf "BATEXEOPTS = %s" "${BATEXEOPTS}" 
     ;;
 	   -L ) shift; LDIR=${1}; LOCAL=(`cat ${1} `);
          if [ -z ${LOCAL}]; then LOCAL=${DEF_LOCAL[@]}; fi
          printf "LOCAL="; printf "%s,\t" ${LOCAL[@]}
     ;;
 	   -C ) shift; CLOUD=${1}; 
          if [ -z ${CLOUD}]; then CLOUD=${DEF_CLOUD}; fi
          printf "CLOUD="; printf "%s,\t" ${CLOUD}
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
