#!/bin/bash
################################################################################
FILENAME=$(basename $0);
#===============================================================================
FILEINFO=( 
    $FILENAME
    'opsim.sh' 
    'Daniel.Collins' 
);
VERSIONING=(
	  '2022-06-07-1504-T'
	  '2022-05-06-1817-T'
	  '2022-05-04-0913-T'
	  '2022-04-22-1114-T'
	  '2022-04-21-1322-T'
	  '2022-04-15-1741-T'
	  '2022-03-31-1646-T'
	  '2022-03-31-1641-T'
	  '2022-03-31-1005-T'
    '2022-03-28-0942-T' 
    '2022-03-22-1027-T'
    '2022-03-06-2258-U'
);
HUB='/home/common/sh' ;
CLIB='/home/common/clib' ;
      sh_runsim="${HUB}/runsim.sh" ;
alias runsim="  . ${HUB}/runsim.sh" ;
alias meshsim=" . ${HUB}/meshsim.sh" ;
#===============================================================================
#  initialise settings quietly from setstar.sh:
. ${HUB}/setstar.sh q ; 
alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+ ;
alias starccm ;

#===============================================================================
  qstar='/home/common/lib/qstar.py' ;
  qstar='/home/common/clib/qstar.py';
  alias qstar=" $qstar $1 " ;

##========================================================= INLINE INPUTS 
#### default inputs...
		DEF_NP=12 ;
	  DEF_xop='g' ;
    OPT_LIC="-power";
		OPT_MPI="-mpi openmpi"; #"" ; # "-mpi openmpi";
		OPT_MPI="";   ## "-mpi openmpi";
		OPT_GRAPH="-graphics mesa_swr";
		OPT_GRAPH="";


while [[ $@# -gt 0 ]] ; do
	key="${1}"
	case "$key" in 
	 r) xop=$key; xop="r"
	 ;;
	 g) xop=$key; xop="g"
	 ;;
	 m) xop=$key; xop="m"
	 ;;
   *) NP=$key ;
	esac
	shift
done 

if [ ${xop} ] ;    ## if $$ has been preset in terminal
		then 	xop=$xop; 
  	else 	xop=$DEF_xop;  ## otherwise use Default setting
fi
if [ ${NP} ] ;    ## if NP has been preset in terminal
		then 	NP=$NP; 
  	else 	NP=$DEF_NP;  ## otherwise use Default setting
fi
if [ $(echo "$NP - 1 >0" | bc -l) -eq 1 ] ; then OPT_NP="-np ${NP}"; else OPT_NP=""; fi

##----------------------------------------------------------------------------

case "${xop}" in 
	g)
		OPERA="gui" ; ## ${OPERA}
		OPT_MPI="-mpi openmpi"; ## "-mpi openmpi";
		OPT_MPI="";   ## "-mpi openmpi";
		OPT_GRAPH="";
		OPT_GRAPH="-graphics mesa_swr";
		DEF_NP=32 
	;;
	r)
		OPERA="run" ; ## ${OPERA}
		OPT_MPI="";
		OPT_MPI="-mpi openmpi"; ## "-mpi openmpi";
		OPT_GRAPH="-graphics mesa_swr";
		OPT_GRAPH="";
		DEF_NP=32 
	;;
	m)
		OPERA="mesh" ; ## ${OPERA}
		OPT_MPI="-mpi openmpi"; ## "-mpi openmpi";
		OPT_MPI="";
		OPT_GRAPH="-graphics mesa_swr";
		OPT_GRAPH="";
		DEF_NP=1 
	;;
esac

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
. opsim.sh {xop} {NP} 
---------------------------------------------------------
 starts a batch execution of starccm+:  operation=${OPERA}
 % starccm+ -np {NP} -batch {$OPERA} {SIMFILE} >> logfile

 {xop[str]} operation mode: { g, r, s }
 
 {NP[int]}  Value is either the input arg 2;
						 Assigned from command prompt, NP=##;
						 otherwise <NP> = $DEF_NP
 {SIMFILE}  Default is most recently modified *.sim file.
---------------------------------------------------------
 ";
##===[ Functions ==========================================
fnow () { 
    now=(`date +%Y%m%d-%H%M%S`); printf $now;
};
loo () { 
    loo=$(ls -tr *log*|ta1) ;
};
pfs () { 
     OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT;
};
pbr () { 
           printf "%s \n" $(pfs '=' 60); };
ADIV=$(pfs '-' 60);
BDIV=$(pfs '=' 60);
PNOW=$(fnow);
status(){
		pbr  
		date 
		ls -latr $PWD/* 
		pbr 
};
status_loo(){
		if [[ -z $loo ]]; then loo=${1} ; fi
		pbr  >>$loo
		date >>$loo
		ls -latr $PWD/* >>$loo
		pbr  >>$loo
};

##=========================================================
OPTIONS="$OPT_LIC $OPT_NP $OPT_MPI $OPT_GRAPH";
doing="starccm -power ${OPT_MPI} -np ${NP} -batch ${OPERA} ${SIMFILE} >> ${loo} " ;
doing="starccm ${OPTIONS[@]} -power ${OPT_MPI} -np ${NP} -batch ${OPERA} ${SIMFILE} >> ${loo} " ;
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
>> Executing: $doing \n $BDIV \n" ;
	}

summary
summary  >$loo

status  >>$loo

##-----------------------------------------------------------------------------
##??  exec ($doing) 
alias starccm

starccm -power ${OPT_MPI} -np ${NP} -batch ${OPERA} ${SIMFILE} >> $loo  ;
##-----------------------------------------------------------------------------

status  >>$loo
tail -n 20 $loo ;

if [[ "${OPERA}" == "run" ]] ; then 
  mkdir   -pv   pp/; 
 	[[ $(ls *.png) ]] && ( mv -vn    *.png pp/ );

	/home/common/lib/qstar.py ; ### exec:python3 qstar ;
  mv -v $loo.stat.txt   ${SIMCASE}.runstat.txt_$(fnow)
  # cp -pvf $loo.stat.txt ${SIMCASE}.runstat.txt_$(fnow) ;
	mkdir -pv  log/;
  cp -vfp --preserve=timestamps *runstat* *run.log* log/;
fi;

status  >>$loo
PNOW=$(fnow) ;
cp -pvf $loo ${SIMCASE}.${OPERA}.log_$(fnow)

printf "
  Finished executing: $(basename $0)
  $( date )
	\n";
#===============================================================================
################################################################################
