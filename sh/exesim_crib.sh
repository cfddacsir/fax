#===============================================================================

_usage="
 ---------------------------------------------------------
 . exesim.sh {NP} {OPT_GRAPHICS} 
 ---------------------------------------------------------
 starts a batch execution of starccm+:  operation=${OPERA}
 % starccm+ -np {NP} -batch {$OPERA} {SIMFILE} >> logfile

 {NP}     Value is either the input arg $1; 
						Assigned from command prompt, NP=##;
						otherwise <NP> = $DEF_NP
 {SIMFILE}  Default is most recently modified *.sim file.

 ";
#===============================================================================
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
	}
#===============================================================================
	OPT_LIC="-power";

	OPERA="gui" ; ## ${OPERA}
	OPT_MPI=""; #"" ; # "-mpi openmpi";
	OPT_GRAPH="-graphics mesa_swr";
	DEF_NP=32 ;

	OPERA="run" ; ## ${OPERA}
	OPT_MPI="-mpi openmpi"; #"" ; # "-mpi openmpi";
	OPT_GRAPH="-graphics mesa_swr";
	OPT_GRAPH="";
	DEF_NP=32 ;

	OPERA="mesh" ; ## ${OPERA}
	OPT_MPI="-mpi openmpi"; #"" ; # "-mpi openmpi";
	OPT_GRAPH="";
	DEF_NP=8 ;
	RUNDIR=$( pwd );
	SIMFILE=$(ls -tr ${RUNDIR}/*.sim | grep -v sim~ | tail -n1 ) ;
	SIMCASE=$( basecase -a ${SIMFILE%%.sim} ) ;
	lulu=${RUNDIR}/${SIMCASE}_${OPERA}.log ;
	if [ $(ls -tr ${lulu} | tail -n1) ]; then
		   cp -vf --preserve=timestamps ${lulu} ${lulu}__$( 
			 printf $(ls -la --time-style='+%Y%m%d-%H%M' ${lulu} |awk '{print $6}')) 
	fi;

#===============================================================================
