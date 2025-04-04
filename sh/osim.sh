#!/bin/bash
################################################################################
FILENAME=$(basename $0);
touch ./BEG_RUNSTAR
#===============================================================================
FILEINFO=( 
    $FILENAME
    'osim.sh' 
    'Daniel.Collins' 
    'Daniel.Collins@enervenue.com' 
);
##---------------------------------------------------------
VERSIONING=(
 '2022-09-15-S-1120' '+ calc_stardur'     
 '2022-05-06-T-1817' 'rev'
 '2022-06-23-S-2055' 'rev '
 '2022-03-06-T-2258' 'rev initial'
);
##---------------------------------------------------------
HUB='/home/common/sh' ;
CLIB='/home/common/clib' ;
      sh_runsim="${HUB}/runsim.sh" ;
alias runsim=" . ${HUB}/runsim.sh" ;
#===============================================================================
#  initialise settings quietly from setstar.sh:
  [ -f ${HUB}/setstar.sh ] && ( sh ${HUB}/setstar.sh q ) ;
  alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+ ;
  alias starccm ;

#===============================================================================
  qstar='/home/common/lib/qstar.py' ;
  qstar='/home/common/clib/qstar.py';
  
#===============================================================================
OPT_LIC="-power";

OPERA="gui" ; ## ${OPERA}
OPT_MPI=""; #"" ; # "-mpi openmpi";
OPT_GRAPH="-graphics mesa_swr";

OPERA="run" ; ## ${OPERA}
OPT_MPI="-mpi openmpi"; #"" ; # "-mpi openmpi";
OPT_GRAPH="-graphics mesa_swr";
OPT_GRAPH="";

DEF_NP=32 ;
RUNDIR=$( pwd );
SIMFILE=$(ls -tr *.sim | grep -v sim~ | tail -n1 ) ;
SIMCASE=${SIMFILE%%.sim} ;
loo=${RUNDIR}/${SIMCASE}_${OPERA}.log ;
if [ $(ls -tr ${RUNDIR}/${loo} | tail -n1) ]; then
     cp -vf --preserve=timestamps ${loo} ${loo}__$( 
		 printf $(ls -la --time-style='+%Y%m%d-%H%M' ${loo} |awk '{print $6}')) 
fi;
##=========================================================

#===============================================================================
usage="
 ---------------------------------------------------------
 . runsim.sh {NP} {OPT_GRAPHICS} 
 ---------------------------------------------------------
 starts a batch execution of starccm+:  operation=${OPERA}
 % starccm+ -np {NP} -batch {$OPERA} {SIMFILE} >> logfile

 {NP}     Value is either the input arg $1; 
						Assigned from command prompt, NP=##;
						otherwise <NP> = $DEF_NP
 {SIMFILE}  Default is most recently modified *.sim file.

 ";
##===[ Functions ==========================================
	fnow () { 
		  now=(`date +%Y%m%d-%H%M%S`); printf $now;
	};
	loo () { 
		  loo=$(ls -tr *log*|ta1) ;
	};
	pbr () { 
           printf "%s \n" $(pfs '=' 60); };
  function pp(){ printf "$1%.s" $(seq 1 $2) ; }
  function pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;};

  ADIV=$(pfs '-' 60);
  BDIV=$(pfs '=' 60 );

	PNOW=$(fnow);
	status(){
		pbr  
		date 
		ls -latr $PWD/ 
		pbr 
	};
	status_loo(){
		if [[ -z $loo ]]; then loo=${1} ; fi
		pbr  >>$loo
		date >>$loo
		ls -latr $PWD/ >>$loo
		pbr  >>$loo
	};
##==============================================================================
get_np(){ ##---------------------------------------------------------
 if [ ${1} ] ;      ## use ARG input value
	then 	NP=${1} ; 
 fi;
 if [ ${NP} ] ;    ## if NP has been preset in terminal
	then 	NP=$NP; 
  else 	NP=$DEF_NP;  ## otherwise use Default setting
 fi
 if [ $(echo "$NP - 1 >0" | bc -l) -eq 1 ] ; then OPT_NP="-np ${NP}"; else OPT_NP=""; fi
 export NP
 printf "%d" "$NP" ;
}
## OPTIONS ##---------------------------------------------------------
while [[ ${#@} -gt 0 ]] ; do
	key="${1}"
	case "$key" in 
	s|q )  ### quiet, launch only server 
		DEF_NP=4;
		OPERA="gui" ;  ### ${OPERA}
		OPT_MPI=" -mpi openmpi" ;
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER=" -server"
 		shift
    NP=$(get_np $1)
	;;
	g )    ### launch server and gui
		DEF_NP=4;
		OPERA="gui" ; ## ${OPERA}
		OPT_MPI="";
		OPT_GRAPH="" ;	 				##### "-graphics mesa_swr ";
		OPT_SERVER=""
 		shift
    NP=$(get_np $1)
	;;
	m ) ### batch-meshing
		DEF_NP=16;
		OPERA="mesh" ; ## ${OPERA}
		OPT_MPI=" -mpi openmpi";
		OPT_GRAPH="" ; 
		OPT_SERVER="" # " -server" ;
    OPT_BATCH=" -batch mesh" ;
 		shift
    NP=$(get_np $1)
    printf "  \n"
  ;;
	r) ### batch-run
		DEF_NP=32;
		OPERA="run" ; ## ${OPERA}
		OPT_MPI=" -mpi openmpi";
		OPT_GRAPH="" ; 
		OPT_SERVER="" # " -server" ;
    OPT_BATCH=" -batch run" ;
 		shift
    NP=$(get_np $1)
    printf "  \n"
  ;;
  esac;
  shift;
done


##==============================================================================
  OPTIONS="$OPT_LIC $OPT_NP $OPT_MPI $OPT_GRAPH";

#  DOSEL="/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+ -power ${OPT_MPI} -np ${NP} -batch ${OPERA} ${SIMFILE} >> ${loo} " ;
  bin_starccm="";
  while [ -z $bin_starccm  ]; do 
    bin_starccm=$(which starccm | grep -v alias );
    
  
  DOSEL="$bin_starccm ${OPT_LIC} ${OPT_GRAPH} ${OPT_MPI} ${OPT_SERVER} -np ${NP} -on ${RSS}:${NP} ${OPT_BATCH} $PWD/${SIMFILE} >> $loo ";
  printf " date: $(date) \n executing ...\n\t $DOSEL ... \n  " ;

summary(){
printf "\n $BDIV \n
 Inputs <--------------------------------------------------
  TIME:     	$PNOW
  RUNDIR:   	$RUNDIR
  SIMFILE:		$SIMFILE
  SIMCASE:  	$SIMCASE
  LOGFILE:  	$loo

OPTIONS:  $OPTIONS
* license:    $OPT_LIC 
* NP:         $NP  / number of processor cores /
* OPT_NP:     $OPT_NP 
* OPERA:      $OPERA / mode: run, mesh, gui, java / 
* OPT_MPI:    $OPT_MPI  / (-mpi openmpi) /
* OPT_GRAPH:  $OPT_GRAPH / (-graphics ) /
* ----------------------------------------------------------
>> Executing: $DOSEL \n $BDIV \n" ;
	}

# touch ./BEG_RUNSTAR

summary
summary  >$loo

status  >>$loo

##-----------------------------------------------------------------------------
##??  exec ($DOSEL) 
  alias starccm

  eval ${DOSEL} 

##-----------------------------------------------------------------------------

status  >>$loo
tail -n 20 $loo ;

if [[ "${OPERA}" == "run" ]] ; then 
	mkdir   -pv   pp/; 
	[[ $(ls *.png) ]] && ( mv -vn *.png pp/ );
  [ -x ${qstar} ] && (
  	exec ${qstar} ; ### exec : python3 qstar.py ;
  );
  mv -v $loo.stat.txt   ${SIMCASE}.runstat.txt_$(fnow)
  # cp -pvf $loo.stat.txt ${SIMCASE}.runstat.txt_$(fnow) ;
	mkdir -pv  rulo/;
  cp -vfp --preserve=timestamps *runstat* *run.log* rulo/;
fi;

status  >>$loo
PNOW=$(fnow) ;
cp -pvf $loo ${SIMCASE}.${OPERA}.log_$(fnow)

touch ./STOP
touch $HOME/STOP
touch ./END_RUNSTAR

#. /home/common/sh/calc_stardur.sh ${OPERA}
. /home/common/sh/calc_stardur.sh run 

#===============================================================================
printf "
  Finished executing: $(basename $0)
  $( date )
	\n";
################################################################################
