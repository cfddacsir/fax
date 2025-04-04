  ##-----------------------------------------------------
  ## Daniel Collins / dcollins@zoox.com /
  ## xkill.sh
  DEF_XPRO="jupyter"
  DEF_XPRO="jupyter"
  DEF_XPRO="xkk"
  usage="
================================================================================
	xkill.sh
//	kills the program of choice
//	option 1.) command argument
//  option 2.) user input
//	option 3.) default program: $DEF_XPRO
//------------------------------------------------------------------------------
// 	DANIEL A. COLLINS  // 
/V  2024-10-25T2242+0700
================================================================================
";
  pg(){  ps -Af | grep ${1} | grep -v "grep" ; }
  pgs(){ 
	  pg $1 | awk '{print $2}'
	  #declare -a L=`pg $1 | awk '{print $2}'`
	  #printf ${L[@]}
  }
  if [[ -n "$1" ]] ; then XPRO=$1; else
  	echo -e "
  	please enter the program name you want to kill
  	type nothing to use default ($DEF_XPRO)";
  	read XA
  	if [ -z $XA ]; then XPRO=$DEF_XPRO; else XPRO=$XA ;fi
  fi
	declare -a MP=`
		 ps -Af | grep ${XPRO} |grep -v grep | awk '{print $2}'`
  printf "the program [ %s ] is running with the following PIDs:\n" $XPRO 
  printf "\t %s " "${MP[@]}"
  for xp in ${MP[@]}
	do
	echo $xp
   	ps -f $xp
    kill -9 ${xp}
  done
  #ps -Af | grep $XPRO | grep -v grep
  print "\n\b"
  ##//END----------------------------------------------
