#!/bin/bash
################################################################################
_info=" ========================================================================
# FILENAME: gifbatch.sh
# AUTHOR:   Daniel Alan Collins (DAC) <Daniel.Collins@enervenue.com>
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=(
 2023-0106-1217u 2023-0127-1116u 2023-0127-1343u 
 2023-0130-1338u 
 2023-0207-1306u
); _rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;
################################################################################
#==============================================================================#
_usage=" 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 gifbatch.sh 
     -w {AWD} -t {prompt for AWD} 
     -p {SWD_PNG} -g {SWD_GIF} 
     -b {SETBASE} -d {SETDELAY}
 >> make animation of several png.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
pp(){ printf "$1%.s" $(seq 1 $2) ; } 
pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;};
pss() { printf "%s\n" $(pfs $1 $2 ) ; } 
showrev(){ printf "\n%s< REV: %s >\n" $(pp '_' 56) ${_rev} ; };
PARA=$(pp \= 60) ;
pdiv(){ printf "\n$PARA\n" ; } 
PDIV=$( printf "\n%s\n" $(pp \= 60) );
here=$(pwd); 
cmdhelp=""; unset cmdhelp; 

#==============================================================================#
DEF_AWD=$PWD ; AWD=$DEF_AWD ;
DEF_SETDELAY="120" ;
DEF_SWD_PNG="$AWD/spp/ssa" ;
DEF_SWD_GIF="$AWD/spp/ani" ;
################################################################################

function getvalues(){
  $AWD=${PWD};
  printf "$PWD"
  ls -d $PWD/*  
  printf "enter path for AWD: ";
  read AWD

  SWD_PNG="$AWD/spp/ssa";
  SWD_GIF="$AWD/spp/ani";

  mkdir -pv $SWD_GIF  ;
  ls        $SWD_PNGg ;
  ls        $SWD_GIF  ;

  declare -a ILIST=("bx" "by" "bz");
  declare -a JLIST=("temp" "flow");
  PNG_BASE="sect" ;
  GIF_BASE="sect" ;
  SETDELAY="120"  ;
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  MAIN EXECUTION
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
exes() { #~~~ #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~# 
  printf "
INSIDE exes() ....
  ";
  declare -a ILIST=("bx" "by" "bz");
  declare -a JLIST=("temp" "flow");

  mkdir -pv $SWD_GIF  ;
  ls        $SWD_PNG  ;
  ls        $SWD_GIF  ;
  
  for i in ${ILIST[@]} ;  do
#      printf "\nmaking animation for Bay_${i}.png " ;
      for j in ${JLIST[@]} ;  do
      case "${kw}" in 
        n)
          seta=(` find ${SWD_PNG} | grep "png" | grep ${i} | grep ${j} | grep -v ${nk} `)
          ANIGIF="${SWD_GIF}/ani_${GIF_BASE}_${i}_${j}.gif" ;
        ;;
        p)
          seta=(` find ${SWD_PNG} | grep "png" | grep ${i} | grep ${j} | grep    ${pk} `)
          ANIGIF="${SWD_GIF}/ani_${GIF_BASE}_${i}_${j}_${pk}.gif" ;
        ;;
        * )
          seta=(` find ${SWD_PNG} | grep "png" | grep ${i} | grep ${j} ` )
          ANIGIF="${SWD_GIF}/ani_${GIF_BASE}_${i}_${j}.gif" ;
        ;;
      esac
      printf " PNG AS INPUT: \n" ; printf "%s \t" ${seta[@]} ;
      printf "\n...  will make : $ANIGIF \n" ;
      printf "\n.... ";

        convert -delay $SETDELAY "${seta[@]}"  ${ANIGIF}

      ls -latrh $ANIGIF ;

      done ;
  done ;
  ## ls -latr *.gif ;


} #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
function set_swd_png(){
 	   AWD=${1}; 
     if [ -z ${SWD_PNG}]; then SWD_PNG="${AWD}/spp/ssa"; fi
     printf "${SWD_PNG}"; 
}
function set_swd_gif(){
 	   AWD=${1}; 
     if [ -z ${SWD_GIF}]; then SWD_GIF="${AWD}/spp/ani"; fi
     printf "${SWD_GIF}"; 
}
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
while [[ ${#@} -gt 0 ]] ; do 
  key="${1}"
  case "$key" in 
 	  -w )    shift ; 
      AWD=${1}; 
#     if [ -z ${AWD} ]; then AWD=${PWD}; fi
      printf "\t AWD= %s \n" ${AWD} 
    ;;
 	  -t ) 
      printf "default PWD: $PWD" ;
      ls -ld $PWD/* 
      printf "enter path for AWD: ";
      read AWD
    ;;
 	  -p )   shift; 
      SWD_PNG=${1}; 
#     if [ -z ${SWD_PNG} ]; then SWD_PNG=$( set_swd_png ${AWD} ) ; fi
      printf "\t SWD_PNG= %s \n" ${SWD_PNG} 
     ;;
 	  -g )   shift; 
      SWD_GIF=${1}; 
#     if [ -z ${SWD_GIF} ]; then SWD_GIF=$( set_swd_gif ${AWD} ) ; fi
      printf "\t SWD_GIF= %s \n" ${SWD_GIF} 
     ;;
 	  -d )   shift; 
      SETDELAY=${1}; 
      if [ -z ${SETDELAY} ]; then SETDELAY=${DEF_SETDELAY} ; fi
      printf "\t SETDELAY= %s \n" ${SETDELAY} 
    ;;
 	  -b )   shift; 
      SETBASE=${1}; 
      if [ -z ${SETBASE} ]; then SETBASE=${DEF_SETBASE} ; fi
      printf "\t SETBASE= %s \n" ${SETBASE} 
    ;;
    -dI  )  
  declare -a ILIST=("bx" "by" "bz");
  printf "using ILIST= ${ILIST[@]}"
    ;;
    -dJ  )  
  declare -a JLIST=("temp" "flow");
  printf "using JLIST= ${JLIST[@]}"
    ;;
    -xI  )  
  # declare -a ILIST=("bx" "by" "bz");
  printf "using ILIST= ${ILIST[@]}"
    ;;
    -xJ  )  shift; 
  # declare -a JLIST=("temp" "flow");
  printf "using JLIST= ${JLIST[@]}"
    ;;
 	  -nk )  shift; 
      kw="n";
      nk=${1}
    
    ;;
 	  -pk )  shift; 
      kw="p";
      pk=${1}

    ;;
 	  -h|--h|--help) 
        cmdhelp="h"; break
     ;;
  esac ## case "$key"  
 shift 
done
if [[ "${cmdhelp}" == "h" ]] ; then
   printf "${_usage}"; (showrev) ;
else 
   ( exes ) ;
fi 

###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<###

unset kw; unset nk; unset pk;

##============================================================================##
printf " END OF EXECUTION : $(date +%s) $(date +%Y%m%d-%H%M) \n" ;
printf "\f \n";
unset cmdhelp; unset here ; unset _here; here=$(pwd) ; _here=$(pwd) ;
##============================================================================##

################################################################################
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
#                             #[[ END OF SCRIPT ]]#                            #
#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~#~~~~
################################################################################

