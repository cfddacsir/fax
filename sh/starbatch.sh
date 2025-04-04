#!/bin/bash

################################################################################
_fileinfo="
#===============================================================================
 FILENAME: starbatch.sh
 AUTHOR:   Daniel Collins, <Daniel.Collins@enervenue.com> [DAC]

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
 2022-1105-1500t 2022-1106-0700u 2022-1107-1019u 2022-1108-1418u 2022-1110-1200u 
 2022-1110-1400u 2022-1110-2000u 2022-1110-2117u 2022-1110-2137u 2022-1111-1210u
 2022-1111-2049u 2022-1111-2100u 2022-1115-1110u 2022-1115-1335u 2022-1115-1608u
 2022-1116-0605u 2022-1116-1755u 2022-1116-1805u 2022-1119-2134u
 2022-1205-0902u 2022-1205-0914u 2022-1205-1015u 2022-1205-1045u 
 2023-0105-0929u 2023-0205-1916u   
 ) ;
_rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;

##============================================================================##
# DEFAULT VALUES
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
unset cmdhelp; unset here ; unset _here; here=$(pwd) ; _here=$(pwd) ;


PATH="${PATH}:/home/dac/sh/:/home/dac/JOBS/" ;
_here=${PWD} ;
RUNSUFFIX="_8hr" ;
POSTMACRO="/home/dac/starmac/proj_escpv/escpv_post.java" ;
ANIMATESH="/home/dac/sh/animake.sh";
DEF_CASECONF="/home/dac/BATJOBS/CASECONF/case.conf" ;
DEF_NPSOLVER=36 ;
DEF_NPMESHER=4 ;       
DEF_NPREPORTER=1 ;
DEF_BASEDIR=${PWD} ;
    BASEDIR=${DEF_BASEDIR} ;
    NPSOLVER=${DEF_NPSOLVER} ;
    NPMESHER=${DEF_NPMESHER} ;
    NPREPORTER=${DEF_NPREPORTER} ;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
BASEDIR="/data/escpv/ph2_stagger" ;
BASEDIR="/data/escpv/ph2w" ;
CASEDIRS=(
  cfgw-v2.50-u0.50
  cfgw-v2.50-u1.00
  cfgw-v2.50-u1.50
  cfgw-v2.50-u2.00
) ;
#==============================================================================="
_usage="
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 runbatch.sh  -b {BASEDIR}  -c {NPSOLVER} -cm {NPMESHER}
              -i {CASECONF} -l {INPCASES} -j {STARMACRO} 
              -o {MODES}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 -h,--h, --help: help usage
 -b  {BASEDIR} :  base work-directory < def: PWD: PWD >
 -r  {NPSOLVER}:  number of processors for computing <def:38 >
 -m  {NPMESHER}:  number of processors for meshging  <def:4  >
 -i  {CASECONF}:  (file)  list of case directories to run in batch listed in file
        (default=/home/dac/JOBS/case.conf )
 -c                use /home/dac/JOBS/case.conf
 -l  {INPCASES}:  (list): list of case directory to run in batch
 -j  {STARMACRO}: pathway-name of java macro being executed 
        (default=/home/dac/starmac/proj_escpv/escpv_post.java)
 -o  {OPERATIONAL_MODE}:
  -o m  |mesh  : meshgen
  -o s  |run   : Solver, compute simulation       (req: mesh)
  -o p  |post  : post-processing java and report  (req: mesh &run)
  -o pg |gif   : generate animation.gifs          (req: mesh &run &post)

  -o y  |sync  : upload postprocessed folder /spp to onedrive 
  -o z  |all   : execute m, s, p, gif, sync 
  -o f  |fein  : fein clear sim   
   << clears mesh from most recent sim and then zips solved sim >>
 -v            : verbosity
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2) ; } 
showrev(){ 
      printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ;
}

##============================================================================##
_future="
 -o {OPERATIONAL_MODE}:
  -o x |auto  : execute all / automatically 
  -o b |bau   : model build, exec model_build.java
  -o g |geom  : geom/cad morph operation
";
##============================================================================##
# Functions 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
# LICENSING ~~~~ #
  lmremash() { source /home/common/sh/lmrema.sh ; } ;
  lmss(){ #~~~
   /home/common/lmutil lmstat -a -c /home/common/lic/starlicense.dat \
  							| grep -e "Users of ccmppower:" -A 6 \
  							| grep -v server_id \
							  | grep -e ":" ;
  } ;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
  alias seek=" find $PWD | grep -i -e " ;
  latest(){ #~~~ [latest() ]
    latest=$(ls -tr $(find . | grep -i -e $1 ) | tail -n1 ); 
    printf "${latest}" ;
  } ; 
  lastfull(){ 
    lastfull=$( latest $1 ) ;      
    printf "${lastfull}" ;
  }
  lastbase(){  
    lastbase=$( basename -a $(lastfull $1) ) ;
    printf "${lastbase}" ;
  }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  reinsim(){ #~~~ [ reinsim() ] ~~~~~~~~~~~~~~~~~~~~~~~~~##
    RDD=spp
    LDD=loo
    latest(){ #~~~ [latest() ]
      latest=$(ls -tr $(find . | grep -i -e $1 ) | tail -n1 ); 
      printf "${latest}" ;
    } ; 
    copylast(){ #~~~ [copylast() ]
      kwend=$1 ;
      lastfull=$( latest $kwend ) ;
      last=$( basename -a ${lastfull} ) ;
      if [ -n ${lastfull} ] ; then
        cp -vfu --preserve=time ${lastfull} spp/${last%%.$kwend} ;
      fi
    }
    ls -latr ;
    ls -latr  *run* *log* *png* ;
    mkdir -p  $RDD; mkdir -p $LDD; 
    rm -fv    STOP ;
    mv -v     *png $RDD/ ;
    mv -v     *run* *log* *STAR *MESHGEN memory* watchtop* *txt $LDD ;
    mv -v     rulo/* $LDD/. ;
    mv -v     $LDD/  $RDD/. ;
    du -cah   *.sim* ;
    du -cah -d 0 . ;
    rm -fv    *.sim~ ;
    du -cah   *.sim  ;
    ls -latrh        ;
    copylast "runstat.txt" ;
    copylast "post.log"    ;
  }  #~~~#~~~ [ reinsim ] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
   
    
##============================================================================##

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function get_lastsim() { #~~~  get_simcase {simpath} 
   simpath=${1} ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
#  lastsim=$(ls -tr ${simpath}/*.sim | grep -v .gz|tail -n1 ) ;
   lastsim=$( find ${simpath} | grep -e ".sim" | grep -v .gz|tail -n1 ) ;
   #simcase=$( basename -a ${lastsim%%.sim} ) ; 
   printf "${lastsim}" ;
  }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function get_simcase() { #~~~  get_simcase {simpath} 
   simpath=${1} ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
   lastsim=$(ls -tr ${simpath}/*.sim | grep -v .gz|tail -n1 ) ;
   lastsim=$( find ${simpath} | grep -e ".sim" | grep -v .gz|tail -n1 ) ;
   simcase=$( basename -a ${lastsim%%.sim} ) ; 
   printf "${simcase}" ;
  }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  tailsim(){ ## tailsim {simpath} 
   simpath=${1} ;
   printf "simpath=${simpath}\n" ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
   lastsim=$(ls -tr ${simpath}/*.sim|grep -v .gz|tail -n1 ) ;
   simcase=$( basename -a ${lastsim%%.sim} ) ; 
   simlog=$(ls -tr ${simpath}/${simcase}*log|tail -n1);
   printf " simcase = $simcase; simlog = $simlog ";
   xterm -title "TAILING CASE : ${simcase}" \
   -geom 480x40 -bg black -fg green \
   -e " tail --retry -n 1000 -f -F ${simlog} " &
  } ##eof ~~~ tailsim ~~~ ##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function show_case() { #~~~
    printf " case to $xb in ${swd} \n" ;
    cd ${swd} ; echo ${PWD} ;
    ls -latr ;
    #( lmss ) ;
    ( date ) ;
    lastsim=$(ls -tr *.sim|grep -v .gz|tail -n1 ) ;
    simcase=${lastsim%%.sim} ; 
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;

    printf " now $xb simulation for %s \n" ${lastsim} ;
    # lmremash; sleep 5s; lmss ;
  }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function new_simname() { #~~~
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    lastsim=$(ls -tr *sim|tail -n1 );
    if [ $(expr index ${lastsim}      '_meshed') -gt 0 ] ; then 
      if   [ $(expr index ${lastsim}  '_nom_meshed') -gt 0 ] ; then 
         simcasebase=${simcase%%_nom_meshed} ;  
      elif [ $(expr index ${lastsim}  '_nom') -gt 0 ] ; then 
         simcasebase=${simcase%%_nom} ;
      else 
         simcasebase=${simcase} ; 
      fi
    fi
    new_simname="${simcasebase}_${RUNSUFFIX}.sim"
    printf "${new_simname}" ;
  } ###EOfunction new_simname ~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function mesh_case() { #~~~
    cd   ${swd};
    show_case | tee -a ${blog};
    ls -latrh *.sim | tee -a ${blog}
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    # tailsim ${swd} &
    #sleep 2m;
    sleep 10s;
    # meshsim.sh ${NPMESHER} ;
    simtee.sh m ${NPMESHER} ;
    mv -v $(ls -tr *sim|tail -n1 ) $(new_simname); #new_simname=$(new_simname);#

    POSTMACRO="/home/dac/starmac/proj_escpv/escpv_postmesh.java";
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    logcase="${swd}/${simcase}.post.log" ;
    starccm+ -power -batch ${POSTMACRO} ${lastsim} | tee -a ${logcase} ; 
  } ###EOfunction mesh_case ~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function run_case() { #~~~
    cd   ${swd};
    show_case | tee -a ${blog};
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    ls -latrh *.sim | tee -a ${blog}
    # tailsim ${swd} &
    #sleep 2m;
    sleep 10s;
    simtee.sh r ${NPSOLVER} ;

   POSTMACRO="/home/dac/starmac/proj_escpv/escpv_postrun.java";
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    logcase="${swd}/${simcase}.post.log" ;
    starccm+ -power -batch ${POSTMACRO} ${lastsim} | tee -a ${logcase} ; 

  } ###EOfunction run_case ~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  ziplast(){ #~~~ [copylast() ]
      kwend=$1 ;
      kwend=$1 ;
      lastfull=$( latest $kwend ) ;
      if [ -n ${lastfull} ] ; then
        gzip -Nqv9 -S .gz $(lastbase $kwend) ;
      fi
  }
  feinsim(){ #~~~ [ feinsim() ] 

    ## process feinclearsim.java
    ( show_case );
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    logcase="${swd}/${simcase}.fein.log" ;
    JMACRO="/home/dac/starmac/clearsim_all.java" ;
    JMACRO="/home/dac/starmac/clearsim_solution.java" ;
    ls -latrh *.sim 
    if [ -n $(expr index $(ls -tr *.sim | tail -n 1) CLEARED) ] ;  then
      starccm+ -power -batch ${JMACRO} ${lastsim} | tee -a ${logcase} ; 
      if [ -f CLEARED.sim ] ; then
        cp -pvfu CLEARED.sim ${lastsim}_CLEARED.sim ;
      fi
      if [ ${lastsim}_CLEARED.sim ] ; then
         gzip -Nqv9 -S .gz ${lastsim} ;
      fi
    fi  
    ls -latrh *.sim 
  }  
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~# 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function post_case() { #~~~
    ( show_case );
    POSTMACRO="/home/dac/starmac/proj_escpv/escpv_postrun.java";
    simcase=$(get_simcase ${swd} ) ;
    lastsim=$(get_lastsim ${swd} ) ;
    logcase="${swd}/${simcase}.post.log" ;
    starccm+ -power -batch ${POSTMACRO} ${lastsim} | tee -a ${logcase} ;
    reinsim ;
    ## Batch mode for macros is run from the command line using the -batch option:
    ## % starccm+ -batch cavity.java file.sim
  } ###EOfunction post_case ~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function eval_exes() { #~~~
    cd $swd ;
    printf "now executing $xb in project dir ${swd} " ;
    cd ${swd} ;
    printf "(eval \"${exes}\"   )\n";
            (eval  "${exes}"    )   ;
  } ###EOfunction eva_exes #~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function postgif_case() { #~~~ 
    exes="${ANIMATESH} -w " ;
    (exes_case);
  } ###EOfunction postgif_case  ~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  function onedir_case() { #~~~
    ##__future__: add line for if -f $onedrive, else . ~/sh/onedrive_mount.sh...
    printf "next case to $xb in ${swd} \n" ;
    swd_full=${swd} ;
    ( date ) ;
    printf "now $xb simulation in project dir ${swd} " ;
    swd_base=$( basename -a ${swd_full} );
    exes=" 
    cd ${swd_full} 
    ( reinsim ) 
    swd_base=${swd_base} 
    dir_source=${swd_full}
    dir_target=~/onedrive/_SIM_/data
    dir_target=~/onedrive/_SIM_/data/escpv
    dir_target=~/onedrive/_SIM_/data/escpv/${swd_base}  
    mkdir -pv                    ~/onedrive/_SIM_/data/escpv/${swd_base}
    rsync -vazr ${swd_full}/spp  ~/onedrive/_SIM_/data/escpv/${swd_base}
    ";
    printf "(eval \"${exes}\"   )\n";
            (eval  "${exes}"    )   ;

  } ###EOfunction onedir_case ~~~#

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      

##============================================================================##
## ~~~# THISCASE FOR LOOP ~~~#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
 function opermodes() { #~~~
   operleg(){
      operkey=${1} ; operdes=${2} ;
      printf " OPERATION CHOICE: %s \n OPERATING MEANS: %s .\n" ${operkey} ${operdes} ;
   }
   while [[ ${#@} -gt 0 ]] ; do 
	    operkey="${1}"
      printf " ~~ Executing this Opermode %s at:\n\t $(date +%s)=$(date +%Y%m%d-%H%M) \n " \
        "${operkey}" ;
	    case "${operkey}" in 
        m|mesh   ) 
            xb="mesh";
            operdes=" m|mesh ${xb}" ;
            ( mesh_case ) ;
            printf "done mode.\n"
        ;;
        s|run    ) 
            xb="run";
            operdes=" s|run ${xb}" ;
            ( run_case ) ;
            printf "done mode.\n"
        ;;
        p|post   ) 
            xb="post";
            operdes=" p|post ${xb}" ;
            ( post_case ) ;
            printf "done mode.\n"
        ;;
        pg|gif   ) 
            xb="postgif_case";  
            operdes=" pg|gif ${xb}" ;
            exes="${ANIMATESH} -w " ; ( eval_exes ) ; #( postgif_case ) 
            printf "done mode.\n"
        ;;
        f|fein   ) 
            xb="feinsim_case";  
            operdes="f |pf |fein ${xb}" ;
            exes=" {NEWSCRIPT_FOR_FEINSIM} " ; 
            
            #  ( eval_exes ) ; 
            ( feinsim ) ;
            printf "done mode.\n"
        ;;
        y|sync   ) 
            xb="onedir_case";  
            operdes=" y|snyc ${xb}" ;
            ( onedir_case ) ;
            printf "done mode.\n"
        ;;
        z|all    ) 
        ####xb="mesh";          ( mesh_case );
            operdes=" z|all :: All stages --run, post, postgif_case, onedir_case" ;
            operleg ${operkey} ${operdes} ;
            xb="run";           ( run_case );
            xb="post";          ( post_case );
            xb="postgif_case";  (  exes="${ANIMATESH} -w " ; eval_exes );
            xb="onedir_case";   ( onedir_case );
            printf "done.\n"
        ;; 
      esac
      shift
   done
 } #~~~  ~~~#
#####++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#####
exes() { #~~~
  printf "\n================================================================================\n";
  printf " 
  \t BASEDIR:  ${BASEDIR}
  \t NPSOLVER: ${NPSOLVER}
  \t NPMESHER: ${NPMESHER} \n" ;
  printf "  \t Cases to process (CASEDIRS):\n" ;
  printf "  \t\t%s\n" ${CASEDIRS[@]} ;
  printf "  \n================================================================================\n";
  
  for thiscase in ${CASEDIRS[@]} ;
  do
    swd="${BASEDIR}/${thiscase}" ;
    cd $swd ;
    ls -latr * | tee -a ${blog}

    printf "\n CASE:${thiscase} \n in basedir ${BASEDIR}\n in casedir ${swd} \n";
    lastsim=$(ls -tr *sim|tail -n1 ) ;
    simcase=${lastsim%%.sim} ; 
#   printf " OPERMODE = ${OPERMODE[@]} \n" ;
     printf "OPERMODE = ${OPERMODE[@]} \n" 
    ( opermodes ${OPERMODE[@]} ) ;
    # ( date +%s ) ;
 done; ###///EO for thiscase in ${CASEDIRS[@]} ///###
 #EOfunction loop_ ~~~#
} #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
#####++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#####

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
  while [[ ${#@} -gt 0 ]] ; do key="${1}" ; 
	  case "$key" in 
	   -b  )  shift; BASEDIR=$1 
              if [ -z $BASEDIR ];then BASEDIR=$DEF_BASEDIR;fi 
     ;;
     -r  )  shift; NPSOLVER=$1 ; 
              if [ -z $NPSOLVER ];then NPSOLVER=$DEF_NPSOLVER;fi 
     ;;
     -m )  shift; NPMESHER=$1; 
              if [ -z $NPMESHER ];then NPMESHER=$DEF_NPMESHER;fi 
     ;;
 	   -i  )  shift; INF=$1 ; CASEDIRS=(`cat $INF`) ;
              if [ -z ${INF} ]; then CASEDIRS=(`cat ${DEF_CASECONF} `);fi 
     ;;
 	   -c  )  shift; INF=$1 ; CASEDIRS=(`cat /home/dac/JOBS/case.cfg`) ;
              if [ -z ${INF} ]; then CASEDIRS=(`cat ${DEF_CASECONF} `);fi 
     ;;
 	   -l  )  shift; 
              if [ -n $1 ]; then 
                CASEDIRS="${1}"; 
              elif [ -n $INPCASES ]; then 
                CASEDIRS="${INPCASES}"; 
              elif [ -z $CASEDIRS ]; then 
                printf "ERROR, no value set for CASEDIRS! "; # ( abort ) ;
              fi 
     ;;
 	   -o)    shift; OPERMODE=$1;  
            # if [-n $1]; then OPERMODE=$1; else OPERMODE="a"; fi ;
     printf "OPERMODE = ${OPERMODE[@]} \n" 
     ;;
 	   -h|--h|--help) cmdhelp="h"; break 
     ;;
    esac 
   shift 
  done ;
  if [[ "${cmdhelp}" == "h" ]] ; then
     printf "${_usage}" ; (showrev) ;
  elif [ -z $CASEDIRS ]; then 
      printf "ERROR, no value set for CASEDIRS! "; 
  elif [ -n $CASEDIRS ]; then
      printf "
 ¨¨¨¨¨ Executing this Opermode %s at:\n\t $(date +%s) $(date +%Y%m%d-%H%M) \n
 ¨¨¨¨¨ \n" \
       "${OPERMODE[@]}" ;
      ( exes ) ;
  fi
##============================================================================##
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%d-%H%M) \n" ;
printf " \f \n";
unset cmdhelp; unset here ; unset _here; here=$(pwd) ; _here=$(pwd) ;
##============================================================================##

################################################################################
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
#                             #[[ END OF SCRIPT ]]#                            #
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
################################################################################
