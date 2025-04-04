#!/bin/bash

################################################################################
_rev=2022-1117-0610u
_fileinfo="
#===============================================================================
 FILENAME: exesim.sh
 AUTHOR:   Daniel Collins, <Daniel.Collins@enervenue.com> [DAC]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
2022-1117-0610u
);
### _rev=${_snv[#{_svn[@]} } ~~ last element of _svn ??
################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~ SETTING DEFAULTS ~~~# #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	HUB='/home/common/sh'   ;
  CLIB='/home/common/lib' ;
	alias runsim="  . ${HUB}/runsim.sh"  ;
	alias meshsim=" . ${HUB}/meshsim.sh" ;
	BINPATH_STARCCM=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/;
	alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+;
	alias starccm ;
  QSTARPY='/home/common/lib/qstar.py' ;
  alias qstar="/home/common/lib/qstar.py $1 " ;
	. ${HUB}/setstar.sh q ; ##// initialise settings quietly from setstar.sh //

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	OPT_LIC="-power"                ;
	OPT_MPI=""                      ; 
	OPT_MPI="-mpi openmpi"          ; 
	OPT_GRAPH="-graphics mesa_swr"  ;
	OPT_GRAPH=""                    ;
	DEF_NP=20                       ;
	RUNDIR=$( pwd )                 ;
	OPERA="gui" ; 

#===============================================================================

#===============================================================================
_usage="
-----------------------------------------------------------
 exesim.sh {NP} [OPTIONS]
 
 starts a batch execution of starccm+: operation=${OPERA}
 % starccm+ -np {NP} -batch {OPERA} {SIMFILE} >> logfile
 {NP}       Value is either the input arg $1
						  Assigned from command prompt, NP={##}
						  otherwise <NP> = ${DEF_NP}

-----------------------------------------------------------
 BATCH OPERATIONS
-----------------------------------------------------------
 -b {OPERA}  )   
  g|gui )     gui
  m|mesh)     mesh generate
  r|run )     run solver
  j|java)     execute java macro (specify java) 
  p|post)     post-process (specify java) 
-----------------------------------------------------------
 OPTIONS
-----------------------------------------------------------
 -f   ):      {SIMFILE}
                 Default is most recently modified *.sim file.

 +og  ):      turn _ON_  \-graphics mesa_swr
 -og  ):      turn _OFF  \-graphics mesa_swr
 +mpi ):      turn _ON_  \-mpi openmpi
 -mpi ):      turn _OFF  \-mpi openmpi

 --help,--h,-h ):
            print usage information and break

"; ##~~~[_usage]~~~## ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~###

#====[ FUNCTIONS ]=============================================================#

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
			pbr  >>$loo ;
			date >>$loo ;
			ls -latr $PWD/* >>$loo ;
			pbr  >>$loo ;
	};
	loo() {
		   loo=$(ls -tr *.log*|ta1);
			 printf $loo;
	};

calcdur(){ ##BOF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	printf "%s" "$PRBR" ;

	BEGSESSION=`ls -la --time-style='+%s' BEGSESSION | awk '{print $6 }'`;
	ENDSESSION=`ls -la --time-style='+%s' ENDSESSION | awk '{print $6 }'`;
	DURSESSION=$(echo "scale=0;  ($ENDSESSION - $BEGSESSION)"    | bc -l );
	DURCALCMIN=$(echo "scale=10; ($ENDSESSION - $BEGSESSION)/60" | bc -l );

	GENSEG=` echo "scale=0; 
	(  $ENDSESSION - $BEGSESSION) / 3600
	(( $ENDSESSION - $BEGSESSION) % 3600) / 60
	(( $ENDSESSION - $BEGSESSION) % 3600) % 60" | bc -l ` ;

	printf "
  BEGSESSION: %d (sec) %s %s
  ENDSESSION: %d (sec) %s %s 
  DURSESSION: %d (sec) " \
$BEGSESSION $(ls -lA1 --time-style=long-iso BEGSESSION) \
$ENDSESSION $(ls -lA1 --time-style=long-iso ENDSESSION) \
$DURSESSION ;
  printf "\n%14s %4d ° %2d\'  %2d\" " ' ' ${GENSEG[@]} ;
  printf "\n%14s %4d h %2d m %2d s  " ' ' ${GENSEG[@]} ;

	printf "\n%s\n" "$PRBR" ;

} ##EOF calcdur() ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##

summary(){
printf "\n $BDIV \n
 Inputs <--------------------------------------------------
  TIME:     	$PNOW
  RUNDIR:   	$RUNDIR
  SIMFILE:		$SIMFILE
  SIMCASE:  	$SIMCASE
  LOGFILE:  	$lulu

OPTIONS:    $OPTIONS
* license:    $OPT_LIC 
* NP:         $NP  / number of processor cores /
* OPT_NP:     $OPT_NP 
* OPERA:      $OPERA / mode: run, mesh, gui, java / 
* OPT_MPI:    $OPT_MPI  / (-mpi openmpi) /
* OPT_GRAPH:  $OPT_GRAPH / (-graphics ) /
* ----------------------------------------------------------
>> Executing: $doing \n $BDIV \n" ;
} ##EOF~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
###==========================================================================###

#===============================================================================
exespre(){
  date;
}

#===============================================================================
function exes(){ ###BOF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
 
  ##---------------------------------------------------------------------------
  ## Warm-up 
	OPTIONS="$OPT_LIC $OPT_NP $OPT_MPI $OPT_GRAPH";
	exstarccm="/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+"; 
	doing="$exstarccm -power ${OPT_MPI} -np ${NP} -batch ${OPERA} ${SIMFILE} >>${lulu}";

  ##---------------------------------------------------------------------------
  touch $BEG ; ##--------------------------------------------------------------
  ##---------------------------------------------------------------------------
  printf "startup $(date +%s )\n\n">$lulu ;
  summary | tee -a $lulu ;
  status  | tee -a $lulu ;
  alias starccm
  ##---------------------------------------------------------------------------

  ##---------------------------------------------------------------------------
  memorywatch.sh i 4 s 15 &
  eval $doing ;
  ##---------------------------------------------------------------------------
  
  ##---------------------------------------------------------------------------
  tail -n 20 $lulu ;
  if [[ "${OPERA}" == "run" ]] ; then 
	  mkdir -pv  rep/loo/;
    [[ $(ls *.png) ]] && ( mv -vn *.png rep/ );
	  /home/common/lib/qstar.py ; ##// exec: python3 qstar.py 
    cp -vfp --preserve=timestamps $lulu.stat.txt  ${SIMCASE}.runstat.txt_$(fnow)
    cp -vfp --preserve=timestamps *runstat* *run.log* rep/loo/;
    mv -v *.png rep/ ;
  fi;
  ##---------------------------------------------------------------------------

  ##---------------------------------------------------------------------------
  status  >>$lulu
  PNOW=$(fnow) ;
  cp -pvf $lulu ${SIMCASE}_${OPERA}.log_$(fnow)
  ##---------------------------------------------------------------------------

  ##---------------------------------------------------------------------------
  touch $END ; ##--------------------------------------------------------------
  ##---------------------------------------------------------------------------

  ##---------------------------------------------------------------------------
  . /home/common/sh/calc_stardur.sh ${OPERA}
  . /home/common/sh/gen_memusage.sh &
  ##---------------------------------------------------------------------------

} ###EOF exes() ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
#===============================================================================

pp(){ printf "$1%.s" $(seq 1 $2); } 
showrev(){ printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ; } 

#===============================================================================
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
__previous__='
	if [ ${1} ] ;      ## use ARG input value
		then 	NP=${1} ; 
	fi;
	if [ ${NP} ] ;    ## if NP has been preset in terminal
		then 	NP=$NP; 
		else 	NP=$DEF_NP;  ## otherwise use Default setting
	fi
	if [ $(echo "$NP - 1 >0" | bc -l) -eq 1 ] ; then OPT_NP="-np ${NP}"; else OPT_NP=""; fi
';

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  while [[ ${#@} -gt 0 ]] ; do 
	  key="${1}"
	  case "$key" in 
      g|gui)
	OPERA="gui" ; 
	OPT_MPI=""; 
	OPT_GRAPH="-graphics mesa_swr";
	DEF_NP=10 ;
  BEG=BEG_STARGUI ;
  END=END_STARGUI ;
  printf "chose $key"
     ;;
     m|mesh) 
	OPERA="mesh" ;
	OPT_MPI="-mpi openmpi"; 
	OPT_GRAPH="";
	DEF_NP=10 ;
  BEG=BEGSESSION ;
  END=END_MESHEGEN ;
  printf "chose $key"
     ;;             
     r|run|s|solve)
	OPERA="run" ; 
	OPT_MPI="-mpi openmpi"; 
	OPT_GRAPH="";
	DEF_NP=32 ;
  BEG=BEG_STARRUN ;
  END=END_STARRUN ;
  printf "chose $key"
     ;;
     j|java) 
	OPERA="java" ; 
	OPT_MPI=""; 
	OPT_GRAPH="";
	DEF_NP=10 ;
  BEG=BEG_OPTPOST ;
  END=END_OPTPOST ;
  printf "chose $key"
     ;;             
 	   -q ) shift; quiet_mode=true ### quiet-mode
     ;;
 	   -h|--h|--help) cmdhelp="h" ; break ### cmdhelp  -- show _usage and exit
     ;;
    esac 
   shift
  done;

###>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
##~~~ __MAIN__ ~~~##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  if [[ "${cmdhelp}" == "h" ]] ; then
     printf "${_usage}"; (showrev) ;
  else 
     ( exes ) ;
  fi 

###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###
##~~~ END OF SCRIPT ~~~##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

printf "\f\f \t ${cmdhelp} \n"; unset cmdhelp;
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%d-%H%M) \n" ;
printf "\f \n";
cd $here ;  unset here ;
################################################################################




