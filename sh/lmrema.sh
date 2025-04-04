#!/bin/bash

################################################################################
_fileinfo="
#===============================================================================
 FILENAME: lmrema.sh
 AUTHOR:   Daniel Collins [DAC] <Daniel.Collins@enervenue.com>
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_rev=2022-1116-0815u
_svn=(
 2022-0711-1205t 
 2022-0926-1400t 
 2022-1116-0815u
); ## _rev=${_snv[#{_svn[@]} } ~~ last element of _svn ??
#==============================================================================#
_usage=" 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 lmrema.sh -q --h|--help
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 -q ) execute in quiet mode
 -h|--h|--help) show usage
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2); } 
showrev(){ 
      printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ;
}
#==============================================================================#

#==============================================================================#
# ARG=${1};  ### detecting "quiet mode"
	export  HUB='/home/common/sh';
#==========================================================
	function pfs() {
     OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;
	};
	PRBR=$(pfs '=' 60); 
#==========================================================
# LMREMA --------------------------------------------------
	KW="Users of ccmppower:"
  alias lmremash='. /home/common/sh/lmrema.sh' ;
	alias lmutil='/opt/Siemens/16.06.008/FLEXlm/11_18_0_0/bin/lmutil' ;
	alias lmstar='lmutil lmstat -a -c /home/common/lic/starlicense.dat' ;
	alias looplm='watch -n 120 . /home/common/sh/lmrema.sh' ;
#	alias lmss='  lmutil lmstat -a -c /home/common/lic/starlicense.dat \
#  							| grep -e "Users of ccmppower:" -A 6 \
#  							| grep -v server_id \
#							  | grep -e ":" ' ;
	alias lmho="lmstar | grep -e $HOSTNAME " ;

  lmrem(){
   lmstar ;
   lmutil lmremove -c $LICDAT_STAR -h ccmppower nickel 1999 $1 ;
  }	
  lmremi(){
   lmstar | grep -e "Users of ccmppower:" -A 7 | grep -v server_id | grep -e ":"
   R=$(
   lmstar | grep -e "Users of ccmppower:" -A 7 \
			    | grep -v -e "server_id " | grep -e ":" | grep -e "start"  \
					| awk '{print $6}' 			  | awk -F ')' '{print $1}'  
      )
   printf "instance to be removed: %s" $R ;
   read -p 'enter handle ' HH ;
	 lmutil lmremove -c $LICDAT_STAR -h ccmppower $NICKELIP 1999 $HH ;
  }
  lmrema(){

		KW='Users of ccmppower:'
		lmstar | grep -e "${KW}"  -A 7 | grep -v server_id | grep -e ":"
		R=$(  lmstar \
            | grep -e "${KW}"  -A 7 \
        	  | grep -v -e "server_id " \
            | grep -e ":" \
            | grep -e "start"  \
	          | awk '{print $6}' \
            | awk -F ')' '{print $1}'  
		    );

		lmstar | grep -e $HOSTNAME;  ## #lmstar | grep -e "$KW" -A 10  
		printf "\n  instance to be remove: %s \n\n " $R ;
		lmutil lmremove -c $LICDAT_STAR -h ccmppower $NICKELIP 1999 $R ;
		lmstar | grep -e $HOSTNAME;  ## #lmstar | grep -e "$KW" -A 10 

   } #eob ~~~ funciton lmrema ~~~##
 



###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# MAIN EXECUTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
 exes(){ ##~~~ exes
  #printf "
  #add the commands here that will be executed when called by while arg\n";
  ( lmrema ) ;
  ( lmss   ) ;
	# lmutil lmstat -a -c /home/common/lic/starlicense.dat 
 } ##eob ~~~ exes

################################################################################



###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
# ARG=${1};  ### detecting "quiet mode"
  while [[ ${#@} -gt 0 ]] ; do 
	  key="${1}"
	  case "$key" in 
 	   -q ) shift; quiet_mode=true ### quiet-mode
     ;;
 	   -h|--h|--help) cmdhelp="h" ; break
     ;;
    esac 
   shift
  done;
###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
  if [[ "${cmdhelp}" == "h" ]] ; then
     printf "${_usage}"; (showrev) ;
  else 
     ( exes ) ;
  fi 
###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
##~~~ END OF SCRIPT ~~~##
printf "\f\f \t ${cmdhelp} \n"; unset cmdhelp;
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%D-%H%M) \n" ;
printf "\f \n";
cd $here ;  unset here ;
################################################################################

