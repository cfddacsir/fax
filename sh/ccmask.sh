#!/bin/bash
###########################################################

##  FILEINFO >============================================
FILEINFO=(
    'ccmask.sh'
    'Daniel.Collins'
    'DAC'
    2022 02 15 1054 T
    );

#==========================================================
	DASH='~dac/sh/'
	MYSH="$HOME/sh/"
      	mybash="$HOME/sh/mybash.sh"
alias 	mybash=" . $mybash; printf \"loading %s\n \" $mybash "

usage='
================================================================================
  ccmask.sh :
   \	Prompts user with menu options to configure launch session of STARCCM+
   \ 	incl session type (gui, server only, mesh, run, java)
   \	selecting version, license, server host, nCPUs, etc.
================================================================================
'
###========================================================

### FUNDAMENTAL VALUES ####################################
		NOW=$(date +%Y%m%d%-H%M%S);
		TICK=$(date +%Y%m%d-%H:%M:%S); TIC=$(date +%s );

###########################################################

###  PARAMS  >=============================================
		unset PH os af;
		def_os=mac;
###========================================================

##  Setting DEFAULT VALUES ====================================================
		apps="/opt"
		unset LICOPT
		RSDEF=$HOSTNAME;
		NPDEF=4;
		DEF_VERS="16.06.008"; ## "13.04.010"
		FAV_VERS="16.06.008";
		SAV_VERS="16.06.008";

		LICSRV=nickel
		DEFLIC=1999@nickel
		server1=nickel
		server2=nickel
		server3="Comsol-Desktop"

## PRIMITIVES  ## ============================================================

## -----------------------------------------------------------------------------


##==============================================================================
## 	HEADER FOR MAKING TIME STAMPS
##==============================================================================

##< function timestamp >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function timestamp(){


  uhr=`date +%H-%M-%S`;
  tag=`date +%Y-%m-%d` ;
  printf "the time is ${uhr} in the day of ${tag} ";
  zeit=${tag}_${uhr}
  ou="OU-${zeit}"
  zt=`date +%Y-%m-%d-UT%H-%M-%S -u `; ##// Zulu Time (UTC)
  yt=`date +%Y-%m-%d-LT%H-%M-%S `;  ##// Localtime

### OUTPUT DIR/FILE
	pf="TEMP"
	od="$HOME/logs/"
	of="${od}/${pf}_${zt}.sav"
	mkdir -p -m=754 $od
	PATH_SAVE=$PATH;
	};

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

##==============================================================================
## Getting options for gui, server, batch - mesh / run
##==============================================================================

##==============================================================================
##	SELECT SESSION TYPE
##==============================================================================
function sel_session(){
  printf " \n
------------------------------------------------------------------------------
   Select the SESSION Type:
  	 server only, client, batch-mesh, batch-run, batch-java, dmproject
------------------------------------------------------------------------------
	  opt    )      SESSION TYPE
	  -------				------------
  * 0 | a  ) .... SERVER only (no client) \t\t [*** DEFAULT]
    2 | b  ) .... Server & CLIENT
    3 | m  ) .... batch  MESH ...........  [ -batch mesh ] // mesh generation
    4 | r  ) .... batch  RUN ............  [ -batch run  ] // compute model
    5 | e  ) .... batch  JAVA_FILE ......  [ -batch java ] // play macro in batch
    6 | d  ) .... dmproject in gui_mode		 [ -dmproject  ] // design_study \n\f

------------------------------------------------------------------------------"
  read -p 'enter selection: <   ' RMODE

	printf "\n
	>>>>>
  \t\t\t\t You selected: %-s
	<<<<<	\n" \
${RMODE}

}; ### function sel_session ##====================================================


##==============================================================================
##	SELECT VERSION
##==============================================================================
## 	REQUEST THE VERSION OF CCM+ and source
  export	DASH='~dac/sh/';export	MYSH="$HOME/sh/"
 	setstar="$DASH/setstar.sh"
  alias	setstar=" . $setstar "

  ###--------------------------------------------------------
  ### Licensing
  PATH_FLEXLM=/opt/flexlm/11_18_0_0/bin/
  PATH=$PATH:$PATH_FLEXLM
  export CDLMD_LICENSE_FILE=1999@192.168.201.39
  COMMONLIC=/home/common/lic/
  LICDAT_STAR=/home/common/lic/star/license_SiemensStarccm_iss20220212.txt
  alias lmstar="lmstat -a -c ${LICDAT_STAR}"
  alias flexstar="flexlog=/home/common/lic/flexstar.log; sudo $PATH_FLEXLM/lmgrd -c ${LICDAT_STAR} -l /home/common/lic/flexstar.log"
  ###--------------------------------------------------------

  ### STAR VERSIONS AND PATHS
  STARVERSIONS=( 16.06.008 16.04.012 )
  STARVERSIONS=( 16.04.012 16.06.008 )
  STARVERSIONS=( 16.06.008 16.04.012 )
  ###----------------------------------------------------------------

  ### default settings-----
	STARVERS=${STARVERSIONS[0]}
	PATH_STARVERS=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/
	PATH_STARBIN=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin
	alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+
	alias star1604=/opt/Siemens/16.04.012/STAR-CCM+16.04.012/star/bin/starccm+
  ###----------------------------------------------------------------

setstar_show(){
   STARBIN=$PATH_STARBIN
   STARPATH=$STARBIN
   printf "\n
 Environmental Variables:
    STARVERS      = $STARVERS
    PATH_STARVERS = $PATH_STARVERS
    PATH_STARBIN  = $PATH_STARBIN

 Licensing:
CDLMD_LICENSE_FILE= $CDLMD_LICENSE_FILE
    PATH_FLEXLM   = $PATH_FLEXLM
    COMMONLIC     = $COMMONLIC
    LICDAT_STAR   = $LICDAT_STAR

 Shortcut Aliases:
  * starccm ... shortcut for starccm+ bin
    $(alias starccm)
  * setstar ... for initializing these settings
    $(alias setstar)

  * lmstar ... see if star license is running
    $(alias lmstar)
  * flexstar ... boot up star license
    $(alias flexstar)
  Pathways in PATH:
    PATH = $PATH
\n"
}
##-----------------------
function sel_version(){
#function setvers(){
   apps='/opt/Siemens'
   printf '\n The versions of star avaiable are:'
   printf '\n SEL# Version >'
   for vers in `seq 0 $(( ${#STARVERSIONS[@]}-1))` ; do
	printf '\n %s ... %s ' ${vers} ${STARVERSIONS[$vers]}
   done
   printf '\n Enter Selection number (SEL#) for the version you wish to load: '
   read sel
   case sel in
    1  )
    	STARVERS=${STARVERSIONS[1]}
    	;;
    0|*)
      STARVERS=${STARVERSIONS[0]}
	;;
   esac
   printf "\n you are using version ${STARVERS} \n"
   PATH_STARVERS=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/
   PATH_STARBIN=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin
   alias starccm=/opt/Siemens/${STARVERS}/STAR-CCM+${STARVERS}/star/bin/starccm+
   PATH=$PATH:$PATH_STARVERS:$PATH_STARBIN
   SEL_VERS=$STARVERS

   export STARBIN="$apps/starccm/${STARVERS}/STAR-CCM+${STARVERS}/star/bin"
   export STAREXE="${STARBIN}/starccm+"
   export SAV_VERS="${STARVERS}"
   alias  mystarccm="${STAREXE}"

   setstar_show

}
function sel_version1(){

## Function last_VERSion {{ ## =============================================
##: looks for path "/apps" that contains cae/cfd sw like starccm
		if [ -n $apps ] ; then
		  if [ -d $apps/starccm ]; then apps=$apps; fi
		fi
		if [ -z "$apps" ] ; then
		  if [ -d /opt/starccm ]; then apps=/opt; fi
		else
		  if [ -d $apps/starccm ]; then apps=$apps; fi
		fi
		echo "apps = ${apps}"

		ARR_VERS=(`ls -Ar $apps/starccm`)

		###echo "available versions of starccm+ (sorted from newest to oldest):  ${ARR_VERS[@]}"
		if [ -n "${ARR_VERS}" ]; then
		  LAS_VERS=${ARR_VERS[0]}
		 printf "\n\t newest version of starccm+ installed on $HOSTNAME = ${LAS_VERS}"
		  DEF_STARPATH="${apps}/starccm/${LAS_VERS}/STAR-CCM+${LAS_VERS}/star/bin/"
		  DEF_STARBIN="${apps}/starccm/${LAS_VERS}/STAR-CCM+${LAS_VERS}/star/bin/starccm+"
		 printf "\n\t  default path for STARBIN = ${DEF_STARPATH} "
#   exit 0
		else "!!! there is no version of starccm+ installed on $HOSTAME !!!";
		   exit 1
		fi
		#export $LAS_VERS

## 	function last_VERSion {

		## REQUEST THE VERSION OF CCM+ and source
		unset CHX_VERS

		ctvers=${#ARR_VERS[@]}
		printf "\t Number of versions is ${ctvers} . \n "
##		printf "Choices of STARCCM+ versions to use : ${ARR_VERS[@]} \n\n\n\"
		printf "\t Possible STARCCM+ versions:  %-13s \n " ${ARR_VERS[@]}
		printf "\n\n\n"

		form00="  \t%-10s )   \t   %-13s -- %s 	\n"
		form01="  \t%-10s )   \t   %-13s ** %s 	\n"
		form02="  \t%-10s )   \t   %-13s -- %s 	\n"
		form03="  \t%-10s )   \t   %-13s -- %s 	\n"

		printf "$form00" "Selector " " Version " " ------ "

		for cver in `seq 0 $((${#ARR_VERS[@]} - 1 )) `
		do
		ever=$((cver + 1))
			if [[ $ever -eq 1 ]] ;
			then
		printf "$form01" $ever ${ARR_VERS[$cver]} "latest version"
			else
		printf "$form02" $ever ${ARR_VERS[$cver]} ""
			fi
		done
		null=0
		printf "$form00"  "$null | [*] " $FAV_STARVERS "Favorite Vers"

		printf "enter selection:
		enter $null or blank for favorite [$FAV_STARVERS] <  "
	  read csel
		printf "You selected: %s " ${csel}

		if [[ -z "${csel}" ]] || [[ "${csel}"=="0" ]] ; then
			printf " USING FAVORITE Version ${FAV_STARVERS} "
			SEL_VERS=$FAV_STARVERS  ;
		else
   		nsel=$(( csel - 1  ))
  	  #if [[ ${csel} -lt 1 ]] ; then; csel=1; nsel=0 ; fi
			SEL_VERS=${ARR_VERS[$nsel]}
		fi

		export STARBIN="$apps/starccm/${SEL_VERS}/STAR-CCM+${SEL_VERS}/star/bin"
		export STAREXE="${STARBIN}/starccm+"
		export SAV_VERS="${SEL_VERS}"
		alias  mystarccm="${STAREXE}"
		printf "\n
		>>>>>

				You have chosen to execute starccm from :
			 	  ${STARBIN} <<<<
				alias for next usage:
					 alias mystarccm=
					`alias mystarccm`
				VERSION saved for future usage:
					${SAV_VERS}
			<<<<<	\n
			"
			STARPATH=$STARBIN
      PATH_SAVE=$PATH; export PATH=$PATH:$STARPATH  ## update PATH with STARPATH
	FLEXLM=$apps/starccm/${SEL_VERS}/FLEXlm/11_14_0_2/bin
	alias lmutil=${FLEXLM}/lmutil
	alias lms='lmutil lmstat -a -c 1999@sun-license01 '
}; ### function sel_version ##====================================================

##==============================================================================
##	SELECT LICENSE
##==============================================================================
function sel_license(){
 CDLMD_LICENSE_FILE=1999@nickel
 lmstat -a -c 1999@nickel |	head -n 2 | tail -n 1
 export CDLMD_LICENSE_FILE
 LICOPT=' -power '
}
function sel_license1(){
	date
	lmutil lmstat -a -c 1999@sun-license01 \
		| head -n 2 | tail -n 1
	lmutil lmstat -a -c 1999@sun-license01 \
		| grep -e "Feature usage info" -A 20 | grep -e ":"
  printf "
------------------------------------------------------------------------------
  Select the type of license to use

  **1 s )  ... serialsession (1x)
    3 d )  ... (10) doetokens for as  PRE/POST
    4 r	)  ... doetokens for hpc RUN
    5 w )  ... powersession

 00 0 z	)  ...   	specify

------------------------------------------------------------------------------"
  read -p 'enter selection:  <  ' RLIC
	printf "\n
	>>>>>
  \t\t\t\t You selected: %-s
	<<<<<	\n" \
  ${RLIC}

  case "${RLIC}" in

    m|91)  . ~/sh/getPodkey.sh
    printf "
    podkey         PODKEY = $PODKEY
    license option LICOPT = $LICOPT          "
    ;;
    k|90)  export PODKEY=$DEF_PODKEY
        export PODKEY
        export LICOPT="-power -licpath ${FLEXLIC} -podkey $PODKEY"
    printf "

    podkey         PODKEY = $PODKEY
    license option LICOPT = $LICOPT
		"
    ;;

		3|d|D)  	export LICOPT="-powerpre"
						  echo "using powerpre "
		;;

		4|r|R)  	export LICOPT=" "
				 		##LICOPT="-tokensonly"
							echo "using doe tokens for run "
		;;

  	5|w|W)  	export LICOPT="-power"
							echo "using POWER-session "
		;;

  *|1|s|S)  	export LICOPT=" "
							echo "using singlesession for prepost (default license ) "
		;;

  esac

	printf "\n
	>>>>>
    License option LICOPT
  \t\t\t\t You selected: %-s
	<<<<<	\n" \
  $LICOPT
}; ### function sel_license ##================================================


##==============================================================================
##	SELECT MACHINE : HOST & NCPU
##==============================================================================
function sel_mach(){

  # %IP/<15/	%PORT/4	%LSRV_VAR_NAME	# Service Descriptioin
  exmach="$HOSTNAME:4"
  hosttr="$HOSTNAME:4"

  ########		MACHINE SELECTION LOOP
	##	//----------------------------------------------------
	## mselectloop=0;  	while [ $mselectloop -eq 0 ] ; do
  mselectloop=1;  while [ $mselectloop -gt 0 ]; do
	if [ -n "${recha}" ]; then
		printf "

		Previously you computed on $rechb using $recha cpus
		?  Execute the same ?

		1 |*  ) Same		     / * Default /
		0 		) change  							    \n"
		read -p 'enter selection: <  ' QYA
		else
		    QYA=0;
		fi
		case "$QYA" in
		1)
		printf "
		----------------------------------------------------------------------------
			you are keeping the setting as before $RSERVER:$NCPU
			 you are computing on $rechb using $recha cpus
		----------------------------------------------------------------------------
		\n"
		;;

		## --------------------------------------------------------------------

		0|*)
		printf " \n	 	---------------------------------------------------------------------------
		Which server set do you want to use. \n

		SERVERS TO PICK

			opt			 )		 SERVER
			-------        	------------
		    1 | a  )		 ${server1}
		    2 | b  )		 ${server2}
		    3 | c  )		 ${server3}
		   00 | z  )		 specify server to use...
		    0 | *  )		 Default / local server = ${RSDEF}

		---------------------------------------------------------------------------
		"
		read -p 'enter selection: <  ' RSX
		printf "You selected: %s " ${RSX}

		 case "${RSX}" in
			a|1) 	RSS="$server1";;
			b|2) 	RSS="$server2";;
			c|3) 	RSS="$server3";;
			z|00)	echo "specify server to use..."; read -p 'enter selection: <  ' RSS;;
			0|*)	RSS=$RSDEF;;
		 esac # case "${RSX}" in

			printf "\n
			>>>>>
			SERVER:
			\t\t\t\t You selected: %-s
			<<<<<	\n" \
			$RSS

		printf "\n
	===========================================================================

		SELECT the number of CPUS (NPs)
		(--------	)    ------------
			opt     )     NP /#CPU
		(--------	)    ------------

        0	| * )			NCPU=$NPDEF * DEFAULT *
       00 | q )		  / Specify number to use... /

        1 | s )		  NCPU=1;;
        4 | w )		  NCPU=4;;
        8 | e )		  NCPU=8;;
       10 | d )		  NCPU=10;;

    ee|16 | f )		  NCPU=16;;
    dd|20 | x )		  NCPU=20;;
    tt|24 | y )		  NCPU=24;;
    ff|32 | v )		  NCPU=40;;
    xx|40 | a )		  NCPU=40;;


  [ 	888 | m )     use machinefile to specify machinelist ] [ not yet active]

	===========================================================================
		enter server NP:
		"
		read -p '  <<  ' NPX
		printf "
		>>>>>
		\t\t\t\\t You selected: %s
		<<<<<	" \
		${NPX}
Menus="
 000|000|X|x)
"
		case "${NPX}" in
      1 | s )		  NCPU=1;;
      4 | w )		  NCPU=4;;
      5 | p )		  NCPU=5;;
      6 | g )		  NCPU=6;;
      8 | e )		  NCPU=8;;
     10 | d )		  NCPU=10;;

  ee|16 | f )		  NCPU=16;;
  dd|20 | x )		  NCPU=20;;
  tt|24 | y )		  NCPU=24;;
  ff|32 | v )		  NCPU=40;;
  xx|40 | a )		  NCPU=40;;

    888 | m )     ;; # use_machinefile ;;
     00 | q )     printf " Specify number of CPUS to use "
      ##  tell them max nr of cores available on client macine...
      ##  cmd: ` ...? ``
      ##  maxcpu=$( ... );
	read -p '[enter integer] > ' NCPU;;
    #< Default Case >
      0	| * )    NCPU=$NPDEF;;

		 esac # case NPX
		## --------------------------------------------------------------------
		esac ##case "$QYA" in

		RSERVER="$RSS:$NCPU"
		printf "
		>>>>>
					You have select to use $NCPU cores on host: $RSS
		<<<<<
		would you like to add another cpu/np?
		Yes = 1
		No 	= 0 (default)
		:"
		read mdo
		case "${mdo}" in
		 yes|Y|1)		mselectloop=1;;
		  no|N|0|*)	mselectloop=0;;
		esac
	done ## while [ $mselectloop -gt 0 ] ;

}; ### function sel_mach ##================================================
##================================================##=======================

## ***********************************************************************

##==============================================================================
##	SELECT SIM FILE
##==============================================================================
function sel_simfile(){
  SIMFILE_LAST=`ls -tr *.sim | tail -n 1`;
  printf "
===============================================================================
  What SIM FILE would you like to use?
  Default is Last sim file in current directory ($SIMFILE_LAST)

	(--------	)    ------------
	  opt     )    [ SIMFILE  ]
	(--------	)    ------------
      0  )       Last sim   [*default]
                  === [ $SIMFILE_LAST ]   >     \n
      1  )       New File (start a new sim file)
      2  )       show & ENTER  simfile in CURRENT directory
      3  )       show & select simfile in CURRENT directory

    SIMFILE/s in $PWD:\n `ls -latrh *.sim`
===============================================================================
  "
  read -p 'enter selection: <  :' SFN
	printf "You selected: %s " ${SFN}
  #....  if SFN is not 0,1,2 but is a string, then let SIMFILE=SFN....
  case "$SFN" in
	    3)  flist=(`ls -t \` find $PWD | grep .sim | grep -v .gz | grep -v csv | grep -v log \` `)
    ifoo=0;
    printf "

		Simfiles listed from NEWEST to OLDEST.
		\n"

#	  printf "[ %3s ] == %-100s < %-16s > \n " "NR" "FILE" "<---last saved--->"
#	  printf "- %3s -    %-100s < %-16s > \n " "---" "------" "-------------"
		printf "\n"
	  printf "< %-16s > : [ %3s ] == %-100s \n" "   TIME SAVED   " " # " " SIM FILE: "
    printf "< %-16s > :   %3s   == %-100s \n" "----------------" "---" "----------------------------------"

    for foo in ${flist[@]}; do
			zfoo=`ls -lA1 --time-style="+%Y-%m-%d--%H%M" $foo | awk '{print $6}' `
			  printf "< %-16s > : [ %3d ] == %-100s \n" $zfoo $ifoo $foo
		  ifoo=$((ifoo + 1))
    done
	  printf "\n Select the #nr on left corresponding to file you wish to open: \n"
    read -p "enter nr:" CFOO
    SIMFILE=${flist[$CFOO]}
    ;;
	    2)  ls -latrh *.sim
  SIMFILE=$SIMFILE
    echo "  Enter the sim file to launch or else nothing to use the default/last ($SIMFILE_LAST):
    "
    read -p 'enter selection: <  '  SIMFILE_READ
    if [ "${SIMFILE_READ}" ] ; then
	    SIMFILE=`pwd`/${SIMFILE_READ};
    else
	    SIMFILE=`pwd`/${SIMFILE_LAST};
    fi ;;
	    1)   SIMFILE="-new"
  echo "

    Creating a ** NEW ** sim file for starccm+


    ";;
      0|*)
    echo "The last sim file used is ****  ${SIMFILE_LAST}";
    SIMFILE=`pwd`/${SIMFILE_LAST};

  esac #  case "$SFN" in

  echo "
    You shall be opening this simfile:
      $SIMFILE.
    "
}; ### function sel_simfile ##================================================

##==============================================================================
##	SELECT OUTPUT
##==============================================================================
function sel_outlog() {
  #unset CHX_LOG
  printf "

  To what path shall you record the job log (logpath)
  Default is last path, $LOGPATH

		  0 ) 	keep with default / last path
   *| 1 )		use current pathway [*DEFAULT] $PWD
		  2 )		store on homepathway [ /home/$USER ]
		  3 )		specify someWHERE else
   (  * )		default
  "
  read -p 'enter selection: <  '  CHX_LOG
  LOGPATH=${PWD}
  case "${CHX_LOG}" in
	  0) LOGPATH=$LOGPATH;;
	  2) LOGPATH="/home/$USER/";; ## mkdir $LOGPATH;;
	  3) echo "please enter the pathway to save log file:"; read LOGPATH; mkdir $LOGPATH;;
	  1|*) LOGPATH=${PWD};;
  esac
  echo "the pathway being used = $LOGPATH.  here are its contents"
  #ls -latr $LOGPATH

  ou="${LOGPATH}/${ou}";

  echo "therefore the new output file = $ou"

		###function jobn {

		p_jctr="/home/common/jobc/"
		i_jctr="/home/common/jobc/i/"
		mkdir -m=754 $p_jctr
		mkdir -m=754 $i_jctr

		lsjobs=(`ls -tA $p_jctr `)
		npjobs=${#lsjobs[@]}
		jx=$((  npjobs + 1))
		echo $npjobs
		echo $jx
		lastjob=${lsjobs}
		printf "the last job nr was ${lastjob}
		this job nr will be $jx"

		if [ $jx -lt 1 ];    then jns="0000$jx"; else
		 if [ $jx -lt 10 ];   then jns="000$jx"; else
		  if [ $jx -lt 100 ];  then jns="00$jx"; else
		   if [ $jx -lt 1000 ]; then jns="0$jx";
		   fi;
		  fi ;
		 fi
		fi
		jobn=$jns
		jobx="$p_jctr/$jobn"
		touch $p_jctr/$jobn

		ls -lAtr $p_jctr  |tail -n 3

}; ### function sel_outlog ##================================================

##==============================================================================
##	EXECUTE IMMEDIATELY ? OR WAIT? or MAKE aNother?
##==============================================================================
function sel_immed() {

  echo ' Do you wish to execute immediately?
	  0	No  (it will only create .sh file and NOT execute)
 *  1	Yes
	  2	No  +  make another  (it will only create .sh file and NOT execute)

	  enter:'
  read IMMED

  ##### START GUI, GEN MEN MESH, COMPUTE, JAVA


    #SIMCASE=${SIMFILE%.sim}
    SIMLF=${SIMFILE##**/}
    SIMCASE=${SIMLF%.sim}
    SIMPATH=${SIMFILE%%/**}
    jos="${LOGPATH}/${SIMCASE}.j${jobn}"
    echo logpath $LOGPATH
    echo simcase $SIMCASE
    echo jos $jos
  # pdof=${LOGPATH}
    pdof="."

}; ### function sel_immed ##================================================

##==============================================================================
##	COMPILING OPTIONS TOGETHER FOR EXECTUION
##==============================================================================

    sheader
    timestamp
    sel_version
    sel_session
    sel_mach
    sel_license
    sel_simfile
    sel_outlog
    sel_immed


  ## CASE RMODE *********************************************************
  yt=`date +%Y-%m-%d-LT%H-%M-%S `;
  case "${RMODE}" in
  ###( JAVA-MACRO )-------------------------------------------------------
      e|5) NOW_CLIENT=0; dof="${pdof}/dojava.sh";
          RJARR=(`ls -t *.java`); RJ_DEF=${RJARR[0]} ;
          echo "Default Java to use: $RJ_DEF"
  ###     picking JAVA FILE       ###
          echo ' list of java files in directory'
          ls -latr ${PWD}/*.java ${SMAC}/*.java ;
          echo 'please enter the java file you wish to execute in the batch:'
          lef=(`ls -tr \`find ${PWD} | grep java\` `)
          lef=(${lef[@]} `ls -tr \`find ${SMAC} | grep java\` `)   ;
          for x in `seq 0 ${#lef[@]}`; do
                  echo " [$x] = ${lef[x]} "
                  elem="${lef[x]}"
                  echo " [$x] = ${elem} "
          done
          read -p 'please enter the java file you wish to execute in the batch:' Q  ;
          RJ=${lef[Q]}
          if [ -z "$RJ" ] ; then RJ=$RJ_DEF; fi;
  ####( java )-------------------------------------------------------
  NOW_CLIENT=0;
  dof="starjava.sh";
  ouf="${jos}.java.log"
  JOBOPT="-batch ${RJ}"
  JOBENR=1
  JOBEXE="${STARPATH}/starccm+ ${LICOPT} -np ${NCPU} -on ${RSS}:${NCPU} -rsh ssh ${JOBOPT} ${SIMFILE}"
     ;;

      r|4)
  ###( RUN COMPUTATION )-------------------------------------------------------

## (================================================)
  NOW_CLIENT=0;
  dof="run.sh";
  ouf="${jos}.run.log"
  JOBENR=1
  JOBOPT='-batch run'
  JOBEXE="${STARPATH}/starccm+ ${LICOPT} -np ${NCPU} -on ${RSS}:${NCPU} -rsh ssh -batch run ${SIMFILE}"
     ;;
      m|3)
  ###( meshgen )--------------------------------------------------------------
  NOW_CLIENT=0;
  dof="mesh.sh";
  ouf="${jos}.mesh.log"
  JOBOPT='-batch mesh'
  JOBENR=1
  JOBEXE="${STARPATH}/starccm+ ${LICOPT} -np ${NCPU} -on ${RSS}:${NCPU} -rsh ssh -batch mesh ${SIMFILE}"
     ;;
      b|2)
  ###( server & client gui )---------------------------------------------------
  NOW_CLIENT=1;
  dof="gui.sh";
  ouf="${jos}.gui.log"
  JOBOPT='-collab'
  JOBENR=1
  JOBEXE="${STARPATH}/starccm+ -server ${LICOPT} -np ${NCPU} -on ${RSS}:${NCPU} ${JOBOPT} ${SIMFILE}"
      ;;
      d|6)
  ###( DESIGN MANAGER (dmproject) )--------------------------------------------
#  JOBOPT=echo "
#  ${STARPATH}/starccm+ -dmproject $( ls -t *.dmprj* | head -n 1 )
#   >> ${jos}.gui.log " > $dof
  NOW_CLIENT=1;
  dof="dmproj.sh"
  ouf="${jos}.dmp.log"
  dmf=`  ls -t *.dmprj* | head -n 1 `
  JOBOPT="-dmproject ${dmf}"
  JOBEXE="${STARPATH}/starccm+ -rsh ssh -dmproject ${dmf}"
  JOBENR=6
      ;;
  ### server only )---------------------------------------------------
      a|0|*)
  NOW_CLIENT=0;
  dof="gui.sh";
  ouf="${jos}.gui.log"
  JOBOPT='-collab'
  JOBEXE="${STARPATH}/starccm+ -server ${LICOPT} -np ${NCPU} -on ${RSS}:${NCPU} ${JOBOPT} ${SIMFILE}"
  JOBENR=1
      ;;
  esac  ### case "${RMODE}" in

#  if [ ${JOBENR} -lt 6 ] ||   if [ -z ${JOBENR} ] ; then
 RSERVER="$RSS:$NCPU"
#  else   JOBEXE="${STARPATH}/starccm+ ${LICOPT} -rsh ssh -dmproject $( ls -t *.dmprj* | head -n 1 ) "
#  fi

  echo "job# ${jobn}, outfile ${ouf} " >> ${ouf}
  ls -latr $SIMFILE  >> ${ouf}
  date +%Y-%m-%d-LT%H-%M-%S >> ${ouf}
  date >> ${ouf}
  pwd  >> ${ouf}
  cat $ouf >> $jobx

### > dof ### ..............................................................................

# ..............................................................................
##  function wr_dof { #---------------------------------------
printf "
	printf \"
	\`echo $pdiv1 \`
	\`ls -latr $SIMFILE \`
	\`date +%Y-%m-%d-LT%H-%M-%S \`
	\`pwd \`
	\`echo $pdiv1 \`
	\" >> ${ouf}
  tail -n   8 $ouf >> $jobx

  #  EXECUTING ---------------------------------------------------------------#
	echo $pdiv1 \n
  ls -latr $SIMFILE
  date +%Y-%m-%d-LT%H-%M-%S
  date
  pwd
	echo $pdiv1 \n

  ${JOBEXE} >> ${ouf}

	#  EXECUTING DONE ----------------------------------------------------------#

	printf \"
	\`echo $pdiv1 \`
	\`ls -latr $SIMFILE \`
	\`date +%Y-%m-%d-LT%H-%M-%S \`
	\`pwd \`
	\`echo $pdiv1 \`
	\" >> ${ouf}

	echo $pdiv1 \n
  ls -latr $SIMFILE
  date +%Y-%m-%d-LT%H-%M-%S
  date
  pwd
	echo $pdiv1 \n

  tail -n   8 $ouf >> $jobx

"	> $dof

  ## cat wr_dof >> $jobf

# ..............................................................................

### < dof ### ..............................................................................

  cat $dof >  ${jos}.${dof}
  cat $dof >> $ouf
  cat $dof >> $jobx

# ..............................................................................
  printf "
##==============================================================================

	You will run this script: [ $dof ]

##==============================================================================
"
	cat $dof

##==============================================================================

# ..............................................................................

##==============================================================================
#		print out save values for next time:
# ..............................................................................
#	-np ${NCPU}
#	-on ${RSS}:${NCPU}
function prt_pos100() { #---------------------------------------

	form="\n%-18s : %-40s //t%s  \n "
	form="  %-18s : %-40s        \n"
	form="  %-18s : %-40s        \n"
	printf " \n	>>> %s
	Values chosen this time: \n" $pdiv1
	printf "$form" "jobn" ${jobn}
	printf "$form" "JOBENR" $JOBENR
	printf "$form" "Starbin" "${STARPATH}/starccm+"
	printf "$form" "LICOPT" ${LICOPT}
	printf "$form" "NCPU" ${NCPU}
	printf "$form" "RSS" ${RSS}
	printf "$form" "JOBOPT" ${JOBOPT}
	printf "$form" "SIMFILE" ${SIMFILE}
	printf "$form" "NOW_CLIENT" ${NOW_CLIENT}
	printf "$form" "OUF" ${ouf}
  printf "\n	<<<<<	"

} ### function prt_pos100 ##==========================================

	prt_pos100
	prt_pos100 >> $ouf



##==============================================================================
##	CASE: RUNNING IMMEDIATELY
##==============================================================================

  ## READ IMMED **********************************************************
  case "$IMMED" in #---------------------------------------
	  2)
  sleep 2s;
  ls -latrh ${STARFILE} $dof
  echo " in current joblist:
  ${joblist[@]}"
  joblist=(${joblist[@]} `ls $dof`);
  printf " new joblist now contains: %s" ${joblist[@]}
  printf "
    You have chosen to repeat script from beginning to add another job.
  \n"
  source ccmask.sh
  ;;

	  0)
  sleep 0.5s;
  echo "You have chosen NOT to execute immediately. Exiting to command prompt";
  sleep 0.5s;
  date; pwd;
  ls -latrh ${STARFILE} $dof
	exit 0
    ;;

	  1|*)
  ##### LAUNCHING STAR
  sleep 0.5s;
  date; pwd;
  ls -latrh ${STARFILE} $dof
  echo "
*****************************************************************************
  Job now starting to execute: $dof
*****************************************************************************

  "
  . $dof &
 	 case "${NOW_CLIENT}" in
			1)
			. ~dcollins/sh/guistarclient.sh
			;;
    esac # if/case $NOW_CLIENT
	  sleep 4s;
    tail -n 1000 -f F `ls -tr *.log | tail -n 1`
    ;;
  esac  ## case "$IMMED" in ##==========================================

##==============================================================================
	# alias lmutil="$apps/starccm/12.04.011/FLEXlm/11_14_0_2/bin/lmutil"
	alias starccm
	alias mystarccm
  jobs



##==============================================================================
## /EOS/ END OF SCRIPT																												##
##==============================================================================

##---(( 	REVISIONING		))------------------------------------------------------

#   sv 2022-02-15-1140-T

##==============================================================================

#		function sheader(){
#		function timestamp(){
#		function sel_session(){
#		function sel_version(){
#		function sel_license(){
#		function sel_mach(){
#		function sel_simfile(){
#		function sel_outlog() {
#		function sel_immed() {
#		function prt_pos100() {
