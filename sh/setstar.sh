#!/bin/bash

################################################################################
_info="
#===============================================================================
 FILENAME: setstar.sh
 AUTHOR:   Daniel Collins, <Daniel.Collins@enervenue.com> [DAC]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=( $(printf "%s" "${_info}") 
 2022-0224-T1208 2022-0330-T2152 2022-0331-T0928 2022-0331-T1002 
 2022-0415-S1741 2022-0422-S1139 2022-0504-S1007 2022-0716-S1400
 2022-0815-S1010 2022-0926-S1400 2022-1009-S1006
 2023-0120-1108u 2023-0124-1046u 2023-0124-1424u 2023-0126-0926u
 2023-0201-1454u 2023-0201-1534u 2023-0203-1913u

); _rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;
unset cmdhelp; # unset here ; here=$(pwd) ;

#==============================================================================#
# SIMCASE=$(basename -a ${SIMFILE%%.sim} ) ; loo=${RUNDIR}/${SIMCASE}_${OPERA}.log ;

	ARG=${1};  ### detecting "quiet mode"
##============================================================================##
# PATHWAYS
  #PATH_BASE=$PATH ;
  PATH_BASE=$(cat /home/common/pathset/pathset.rc) ;
  PATH=$(cat /home/common/pathset/pathset.rc) ;
##============================================================================##
# Major/Default Paramenters
#-------------------------------------------------------------------------------
	prrep() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf $OUT ; }
  prrep() { printf $(printf "%${2}s"|sed "s/ /${1}/g") ; } ;
	PRBR=$(prrep '=' 60); 
	export  HUB='/home/common/sh';
	export  MYSH="$HOME/sh/";
	setstar="$HUB/setstar.sh";
	alias setstar=" . ${HUB}/setstar.sh " ;
	alias ses="     . ${HUB}/setstar.sh " ;

	alias runsim=". ${HUB}/simtee.sh r 38"; ###alias runsim=". ${HUB}/runsim.sh";
	starport=47827;
	export   starport ;
	#printf "starport (default) = ${starport}" ;
	export NICKELIP=192.168.201.141;

  RSS=${HOSTNAME}
  DEF_NP=20;
	OPERA="gui" ; ## ${OPERA}
	OPT_MPI="-mpi openmpi";
  OPT_GRAPH="-graphics mesa_swr";
	RUNDIR=$( pwd );
  dostar_defaults()
  {
	SIMFILE=$(ls -tr *.sim | grep -v sim~ | tail -n1 ) ;
  SIMCASE=$(basename -a ${SIMFILE%%.sim} ) ; loo=${RUNDIR}/${SIMCASE}_${OPERA}.log ;
  SEL="starccm -power ${OPT_GRAPH} ${OPT_MPI} -np ${NP} ${SIMFILE} "
  }

##============================================================================##
# alias set 1
#-------------------------------------------------------------------------------

  alias gestar='    starccm -power  ';
  alias gostar20='  starccm -power  -mpi openmpi -np 20 ';
  alias gostar32='  starccm -power  -mpi openmpi -np 32 ';
  alias sap='       starccm         -port 47827         ';
  alias show_usage='
  set | grep -e "gostar () "   -A 40 | grep -e "usage:  gostar <{NP}>"  -A4 ;
  set | grep -e "guistar () "  -A 40 | grep -e "usage:  guistar <{NP}>" -A4 ;
  ';

  alias ccmask=". /home/dac/sh/ccmask.sh "
	alias starp='starccm -power'
	alias starg='starccm -power -graphics mesa '

##============================================================================##
# Licensing
#-------------------------------------------------------------------------------
	PATH_FLEXLM=/opt/Siemens/16.06.008/FLEXlm/11_18_0_0/bin
	## PATH=$PATH:$PATH_FLEXLM
	export CDLMD_LICENSE_FILE=1999@192.168.201.141
	COMMONLIC=/home/common/lic/
	LICDAT_STAR=/home/common/lic/starlicense.dat
	flexlog=/home/common/lic/flexstar.log

  alias lmutil='/opt/Siemens/16.06.008/FLEXlm/11_18_0_0/bin/lmutil' ;
	alias lmstar="lmutil lmstat -a -c ${LICDAT_STAR}" ;
	alias flexstar="
	    flexlog=/home/common/lic/flexstar.log; 
	    sudo $PATH_FLEXLM/lmgrd -c ${LICDAT_STAR} -l $flexlog ;
      sleep 30s ;
      tail -n 30 $flexlog ; " ;
  alias flexstar=" . /home/common/lic/flexstar.sh " ;
	alias lmstar='lmutil lmstat -a -c /home/common/lic/starlicense.dat' ;
#  alias lmremash="   . /home/common/sh/lmrema.sh" ;
  alias lmremash='. /home/common/sh/lmrema.sh' ;
	alias lmho="   lmstar | grep -e $HOSTNAME " ;
  alias looplm=' watch -n 120 . /home/common/sh/lmrema.sh ' ;
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
 
  alias rea=" lmss;  . /home/common/sh/lmrema.sh" ;
  alias looplm=" lmss ; watch -n 120 lmrema.sh " ;
  #alias remstar=". ${HUB}/lmremstar.sh " ;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  get_simcase() { #~~~  get_simcase {simpath} 
   simpath=${1} ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
   lastsim=$(ls -tr ${simpath}/*.sim|grep -v .gz|tail -n1 ) ;
   simcase=$( basename -a ${lastsim%%.sim} ) ; 
    printf "${simcase}" ;
  }
  tailsim(){ ## 
   simpath=${1} ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
   lastsim=$(ls -tr ${simpath}/*.sim|grep -v .gz|tail -n1 ) ;
   simcase=$( basename -a ${lastsim%%.sim} ) ; 
   simlog=$(ls -tr ${simpath}/${simcase}*log|tail -n1);
   xterm -title "TAILING CASE : ${simcase}" \
   -geom 480x40 -bg black -fg green \
   -e " tail --retry -n 1000 -f -F ${simlog} " &
  } ##eof ~~~ tailsim ~~~ ##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#   

#-------------------------------------------------------------------------------
#\\\\\\\\\\\\\\\\\ ENDE: LICENSING \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
##============================================================================##
# STAR VERSIONS AND PATHS
##----------------------------------------------------------------------------##
  ### default values --------------------
	STARVERSIONS=( 16.04.012 16.06.008 )
	STARVERSIONS=( 16.06.008 16.04.012 )
	STARVERS=${STARVERSIONS[0]}
	PATH_STARVERS=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/
	PATH_STARBIN=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin
	alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+
	alias star1604=/opt/Siemens/16.04.012/STAR-CCM+16.04.012/star/bin/starccm+
  ## PATH=$PATH:$PATH_STARVERS:$PATH_STARBIN ;
  ###---------------------------------------------------------------------------
version_1606008(){
	STARVERS=${STARVERSIONS[0]}
	PATH_STARVERS=/opt/Siemens/16.06.008/STAR-CCM+16.06.008
	PATH_STARBIN=/opt/Siemens/16.06.008/STAR-CCM+16.06.008/star/bin/
	alias star1606=/opt/Siemens/16.06.008/STAR-CCM+16.06.008/star/bin/starccm+
}; #------------------------------------------------------------------------#   
###---------------------------------------------------------------------------
version_1604012(){
	STARVERS=${STARVERSIONS[1]}
	PATH_STARVERS=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/
	PATH_STARBIN=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin
	alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+
	alias star1604=/opt/Siemens/16.04.012/STAR-CCM+16.04.012/star/bin/starccm+
}; #------------------------------------------------------------------------#   
## ========================================================================== ##
setstar_show(){
  printf "\n$PRBR\n INITIATING SETTINGS FOR STARCCM+ \n
-> Environmental Variables:
     STARVERS      = $STARVERS
     PATH_STARVERS = $PATH_STARVERS
     PATH_STARBIN  = $PATH_STARBIN
     PATH          = $PATH
-> Licensing Variables:
     PATH_FLEXLM   = $PATH_FLEXLM
     CDLMD_LICENSE_FILE = $CDLMD_LICENSE_FILE
     COMMONLIC = $COMMONLIC
     LICDAT_STAR = $LICDAT_STAR \n" ;
# printf "\n  Aliases with star ....\n"; 
#  alias | grep star;
  printf "$PRBR\n";

}; #------------------------------------------------------------------------#   
## ========================================================================== ##
function setvers(){
  printf '\n The versions of star avaiable are:' ;
  printf '\n SEL# Version >' ;
  for vers in `seq 0 $(( ${#STARVERSIONS[@]}-1))` ; do
      printf '\n %s ... %s ' ${vers} ${STARVERSIONS[$vers]}
  done;
  printf '\n Enter Selection number (SEL#) for the version you wish to load: ';
  read sel ;
  case $sel in
    1  )
    	STARVERS=${STARVERSIONS[1]}
    	;;
    0|*)
        STARVERS=${STARVERSIONS[0]}
	;;
  esac
  printf "\n you are using version ${STARVERS} \n" ;
  PATH_STARVERS=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/ ;
  PATH_STARBIN=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin ;
  alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+ ;
  PATH=$PATH:$PATH_STARVERS:$PATH_STARBIN ;
  setstar_show

}; #------------------------------------------------------------------------#   

#-------------------------------------------------------------------------------
#\\\\\\\\\\\\\\\\\ ENDE:: STAR VERSIONING \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
##============================================================================##
  qstar='/home/common/clib/qstar.py';
  qstar='/home/common/lib/qstar.py' ;
  alias qstar=" $qstar $1 " ;
##============================================================================##

##============================================================================##

##============================================================================##
# functions/alias for launching star / guistar
#-------------------------------------------------------------------------------

###============================================================================###
function estar(){
  ostar=${1}
  NP=${2}
  SIMFILE="";
  RSS=${HOSTNAME}
  DEF_NP=4;
	OPERA="gui" ; ## ${OPERA}
  OPT_LIC=" -power"  
	OPT_MPI=" -mpi openmpi" ;
			##OPT_GRAPH=" -graphics mesa_swr " ;
  OPT_GRAPH="" ;
  OPT_BATCH="" ;
  if [ $NP ]; then NP=$NP; fi
  if [ ${2}  ]; then NP=${2};  else NP=$DEF_NP; fi
  usage=$(printf "#--------------------------------------
  usage:  estar <1: o> <2: NP> 
  < o (str): exec option >
      q = server only (don't launch gui at this time)
      g = gui ( start server & launch gui ) 
      m = batch mesh
      r = batch run
  < NP (int): number of processors >
      arg 2, NP, DEF_NP ($DEF_NP)
  "	);
	#  if [ ${1}="help" ]; then printf "usage: $usage \n "; else
  #----------------------------------------------------------
	case "${ostar}" in 
	k )  ### load specific file for SIMFILE
		DEF_NP=4;
		OPERA="gui" ;  ### ${OPERA}
		OPT_MPI=" -mpi openmpi" ;
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER=" -server";
    shift;
	  SIMFILE=${1}
		;;
	g )    ### launch server and gui
		DEF_NP=4;
		OPERA="gui" ; ## ${OPERA}
		OPT_MPI="";
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER=""
		;;
	f )    ### launch with 1 full cpu-socket
		DEF_NP=20;
		OPERA="gui" ; ## ${OPERA}
		OPT_MPI=" -mpi openmpi";
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER="" # " -server"
		;;
	m )    ### batch-meshing
		DEF_NP=12;
		OPERA="mesh" ; ## ${OPERA}
		OPT_MPI=" -mpi openmpi";
		OPT_GRAPH="" ; 
		OPT_SERVER="" # " -server" ;
    OPT_BATCH=" -batch mesh" 
		;;
	q|*)  ### quiet, launch only server 
		DEF_NP=4;
		OPERA="gui" ;  ### ${OPERA}
		OPT_MPI=" -mpi openmpi" ;
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER=" -server"
		;;
	esac #----------------------------------------------------------
  if [ $NP ]; then NP=$NP; fi
  if [ ${2}  ]; then NP=${2};  else NP=$DEF_NP; fi
	RUNDIR=$( pwd );
  if [ -z ${SIMFILE} ] ; then
	SIMFILE=$(ls -tr *.sim | grep -v sim~ | grep -v gz | tail -n1 ) ;
  fi
	SIMCASE=${SIMFILE%%.sim} ;
	loo=${RUNDIR}/${SIMCASE}_${OPERA}.log ;
	if [ $(ls -tr ${loo} | tail -n1) ]; then
		   cp -vf --preserve=timestamps ${loo} ${loo}__$( 
			 printf $(ls -la --time-style='+%Y%m%d-%H%M' ${lulu} |awk '{print $6}')) 
	fi;
  SEL="starccm ${OPT_LIC} ${OPT_GRAPH} ${OPT_MPI} ${OPT_SERVER} -np ${NP} -on ${RSS}:${NP} ${OPT_BATCH} $PWD/${SIMFILE} >> $loo ";
  printf "  date: $(date) \n  executing ... \n"
  printf "$SEL" ; printf "... \n  " ;
  case "$ostar" in 
  m ) 
			. simtee.sh m $NP &
#			. memorywatch.sh i 5 s 300 & 
			. memorywatch.sh i 4 s 15  & 
      tail -n 10000 -F -f $(ls -tr *.log ) 
  ;; 
  r )  
			. simtee.sh r $NP &
      tail -n 10000 -F -f $(ls -tr *.log )
  ;; 
  * ) eval $SEL 
  ;;
  esac 
} ##__________________________________________________________________________##
##\\\\\\\\\\\\\\\\ ENDOF: function estar(){}
###============================================================================###
function get_starport(){
  starport=$( 
				head -n 10000 $(ls -tr *.log |tail -n1) | grep -e Server | tail -n 1 |\
				awk -F ' ' '{print $3}' | \
				awk -F ":" '{print $2 }' );
  export starport ;
  printf "${starport}" ;
}
function starport_gui(){
  starport=$( 
				head -n 100 $(loo) | grep -e Server | \
				awk '{print $3}' | \
				awk -F ":" '{print $2 }' );
  export starport ;
  printf "starport is: ${starport}" ;
  starccm -port ${starport} ;
}
function starport_sel(){
  starport=$( 
				head -n 100 $(loo) | grep -e Server | \
				awk '{print $3}' | \
				awk -F ":" '{print $2 }' );
  printf " starport identified in log ${starport} 
  do you wish to use this starport? 
		1) yes		|     2) enter other  |    3) cancel "; 
  read -p ':' sel ;
  case "${sel}" in 
  1) 
		starport=$starport
  ;;
  2) 
		printf "enter last digit of starport";
		read -p ':' sel2;
 		starport="4782${sel2}"
  ;;
  3) 
  	exit
  ;; 
  esac;
  printf " launching starccm -port ${starport}" ;
  starccm -port ${starport} ;
}

function starport_def(){
  starport=47827;
  #export starport ;
  printf "starport (default) = ${starport}";
  starccm -port ${starport} ;
}
##------ alias with starccm -port ...
	alias sap='  starccm -port $(get_starport) ' ;
	alias sap7=' starccm -port 47827 ' ;
	alias sap8=' starccm -port 47828 ' ;
	alias sapo=' starccm -port $1 ' ;
  alias starse=' starport_sel ';               

##========= esse, essa 
function esse(){
 	lmss;
 	printf "  launching estar q 8 ....	" ;
  estar 8 q & 
  printf " waiting  ....." ;sleep 7s; 
  starport_sel ;
  
}
function essa(){
  op=${1}; 
  if [ -z ${op} ] ; then op=8; fi
 	lmss;
 	printf "  launching estar q 8 ....	\n" ;
  estar q $op & 
  sleep 2s; 
  printf " waiting a few seconds to get starport \n ";
  for s in `seq 1 7`; do sleep 1s; printf "\n . "; done
  starport=$(printf $(get_starport)) ;
  printf ". \n  "; 
  printf " launching starccm -port ${starport}" ;
  starccm -port $(get_starport)
}
#\\\\\\\\\\\\\\\\\ENDE: STARPORT .....

	function meshgen() {
    np=16; if [ ${1} ] ; then np=${1}; fi
		memorywatch.sh s 15 i 4    & 
		meshsim.sh $np             & 
	}

##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ 
function starpostrun(){
   if [ -z ${1} ] ; then NP=${1}; else NP=1; fi
   ## nr of processors while exec batch -java
   STARJAVA="/home/dac/starmac/proj_escpv/escpv_post.java" ;
   STARJAVA="/home/dac/starmac/proj_escpv/escpv_postrun.java" ;
   SIMCASE=$(get_simcase) ; 
   SIMFILE="${SIMCASE}.sim" ;
   THISLOG="${SIMCASE}.post.log" ; 
   printf "
   ${PRBR} 
   $(date -s ) $(date )
   post processing ${SIMFILE} using java ${STARJAVA} and recording in ${THISLOG}
   \n ${PRBR} \n" ; 
   #if [ $(expr index "${1}" \-h ) -gt 0 ]; then set | grep -e 'starpostmesh() ' -A 15 ; fi #else
   starccm+ -info ${SIMFILE} | tee -a ${THISLOG}
   starccm+ -power -np ${1} -batch ${STARJAVA} ${SIMFILE} | tee -a ${THISLOG} ;
   #fi
}
##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ ##\\\\\\\\\\\\\\\\ 
function starpostmesh(){
   # NP=${1} ;  
   if [ -z ${1} ] ; then NP=${1}; else NP=1; fi
   ## nr of processors while exec batch -java
   STARJAVA="/home/dac/starmac/proj_escpv/escpv_postmesh.java" ;
   SIMCASE=$(get_simcase) ; 
   SIMFILE="${SIMCASE}.sim" ;
   THISLOG="${SIMCASE}.postmesh.log" ; 
   printf "
   ${PRBR} 
   $(date -s ) $(date )
   post processing ${SIMFILE} using java ${STARJAVA} and recording in ${THISLOG}
   \n ${PRBR} \n" ; 
   #if [ $(expr index "${1}" \-h ) -gt 0 ]; then set | grep -e 'starpostmesh() ' -A 15 ; fi #else
   simcase=${getsim%%.sim} ;
   starccm+ -info ${SIMFILE} | tee -a ${THISLOG}
   starccm+ -power -np ${1} -batch ${STARJAVA} ${SIMFILE} | tee -a ${THISLOG} ;
   #fi
}
function starjava (){
   getsim=${1} ;
   starmac="/home/dac/starmac/" ;
   if [ -z ${getsim} ]; then getsim=$(latest sim) ; fi 
   if [ -z ${2}      ]; then 
    ls -latr $( find ${starmac}/ | grep java | tail -n 10 ) 
    read q -p "enter java file: ";
    dojava="${starmac}/${q}";
   fi 
   simcase=${getsim%%.sim} ;
   starccm+ -info ${getsim} | tee -a ${simcase}.log
   starccm+ -power -batch ${dojava} ${getsim} | tee -a ${simcase}.log
}

function starclearall(){
   dojava="/home/dac/starmac/clearsim_all.java" ; 
   getsim=${1} ;
   simcase=${getsim%%.sim} ;
   if [ -z ${getsim} ] ; then getsim=$(latest sim) ; fi 
   if [ -z ${2}      ] ; then NP=${2}; else NP=1; fi
   starccm+ -info ${getsim} | tee -a ${simcase}.log
   starccm+ -power -np ${NP} -batch ${dojava} ${getsim} | tee -a ${simcase}.log
}
function starclearsol(){

   dojava="/home/dac/starmac/clearsim_all.java" ; 
   dojava="/home/dac/starmac/clearsim_solution.java" ; 
   getsim=${1} ;
   simcase=${getsim%%.sim} ;
   if [ -z ${getsim} ] ; then getsim=$(latest sim) ; fi 
   if [ -z ${2}      ] ; then NP=${2}; else NP=1; fi
   starccm+ -info ${getsim} | tee -a ${simcase}.log
   starccm+ -power -np ${NP} -batch ${dojava} ${getsim} | tee -a ${simcase}.log
}

##============================================================================##

if [ -z ${ARG} ]; then ( setstar_show ) ; printf "\n setstar done. " ; fi ;   ## ##### ##### if [ ${ARG} ]; then q=1; else 

##============================================================================##
################################################################################
