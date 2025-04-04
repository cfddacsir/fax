#!/bin/bash

################################################################################
## make animation based on plots made in Py.
unset _help;

_fileinfo="
#==============================================================================#
# File Header Info     
#-------------------------------------------------------------------------------
# FILEINFO=(                     
#  FILENAME:  animake.sh
#  author:   'Daniel.Collins' 'DAC' 'Daniel.Collins@enervenue.com'  
# );
# VERSIONING=(
#  '2022-1025-1414t' '2022-1109-1638u' '2022-1110-1200u'
# );
#
#==============================================================================#"

_usage="
#-------------------------------------------------------------------------------
 animake.sh -a -b -c {} -d {} -i {} -f {} -g {} -h|--help 

  -h,--help   helpful hints
  -a [{LIST}]  list KWA eg bx, by, yz, define as KWA before executing
  -b [{LIST}]  list KWB eg temp, flow, define as KWB before executing
  -kp {STR }  keywords for PNG_BASE  <def: \sect\
  -kg {STR }  keywords for GIF_BASE  <def: same as PNG_BASE >
  -d  {INT}   setdelay value <def: 120>
  -w          used PWD as maindir <default> 
  -c  {PATH}  maindir for processing (SWD_MOD)
  -i  {PATH}  subdir for getting PNG <def: proj/spp/ssa > (SWD_PNG)
  -g  {PATH}  subdir for saving  GIF <def: proj/spp/ani > (SWD_GIF)

#-------------------------------------------------------------------------------
                                                        < REV: 2022-1110-1200u >
";

_future="
  -m          query value for    maindir
  -r          repeat 
  -f  {FILE}  in file list of case directories to run in batch
";
#==============================================================================#
#  SETTING DEFAULTS 
  declare -a DEF_KWA=("bx" "by" "bz");
  declare -a DEF_KWB=("temp" "flow");
  SETDELAY="120" ;
  SWD_MOD=${PWD};
  SWD_PNG="/spp/ssa";
  SWD_GIF="/spp/ani";
  PNG_BASE="sect"; 
  ## GIF_BASE=$PNG_BASE ;

#==============================================================================#
function get_proj () { 
  printf "$PWD"
  ls -d $PWD/*  
  printf "enter path for SWD_MOD: ";
  read SWD_MOD
  printf "$SWD_MOD" ;
}
#==============================================================================#
function _cleanup(){
  unset KWA KWB SWD_MOD SWD_GIF SWD_PNG PNG_BASE GIF_BASE DELAY 
} ####EO _cleanup() 
function _help(){
  printf "$_usage" ;
}
#==============================================================================#
function _make(){
  ### TEMPLATE: convert -delay 150 $(ls -tr ssa/sect_bz_temp*.png) ani/sect_bz_temp.gif
  #  printf "\tusing KWA: %s \n" ${KWA[@]} ;
  #  printf "\tusing KWB: %s \n" ${KWB[@]} ;
  printf "
Parameter Values :
  SWD_MOD     ${SWD_MOD}
  SWD_PNG     ${SWD_PNG}
  SWD_GIF     ${SWD_GIF}
  PNG_BASE    ${PNG_BASE}
  GIF_BASE    ${GIF_BASE} 
  KWA         ${KWA[@]} 
  KWB         ${KWB[@]} 
  DELAY       ${SETDELAY}
  " # "${KWA[@]}" "${KWB[@]}" ;

  mkdir -p  ${SWD_MOD}/$SWD_GIF ;

  # # # ls $SWD_PNG ;# ls $SWD_GIF ;
    
  for i in ${KWA[@]}
  do
    for j in ${KWB[@]}
    do
      inpfiles=$(ls ${SWD_MOD}/${SWD_PNG}/${PNG_BASE}*.png | grep ${i} | grep ${j} );
      ANIGIF="${SWD_MOD}/${SWD_GIF}/ani_${GIF_BASE}_${i}_${j}.gif" ;

      printf "\n  Making animation : $ANIGIF  \n  .... .... ";

      convert -delay ${SETDELAY} ${inpfiles[@]} ${ANIGIF} ;
      ls -latrh $ANIGIF ;

    done ;
  done ;
  ls -latr *.gif ;
  printf "\ndone script.\f\n " 

} ####EO _make() 

#==============================================================================#
while [[ ${#@} -gt 0 ]] ; do ## INPUT ARGUMENTS AS OPTIONS 
	key="${1}"
	case "${key}" in 
   -h|--help) _help=1; break
       ;;
   -a)  shift; unset KWA; KWA=${1}   
         printf "\t Using imported value for KWA: $KWA \n" ; # ${KWA[@]} ;
         printf "\n" 
       ;; 
   -b)  shift; unset KWB; KWB=${1}    
         printf "\t Using imported value for KWB: $KWB \n" ; #${KWB[@]} ;
         printf "\n" 
       ;; 
   -c)  shift; SWD_MOD=$1  ;;
	 -i)  shift; SWD_PNG=$1   ;; # SWD_GIF=$SWD_PNG ;;
   -g)  shift; SWD_GIF=$1   ;;
   -kp) shift; PNG_BASE=$1  ;;
   -kg) shift; GIF_BASE=$1  ;;

   -d)  shift; SETDELAY=$1  ;;
   -w)  shift; SWD_MOD=$PWD ;;

   ## -m) SWD_MOD=$(get_proj ) ;;

   ## -f) shift; shift      ;; ## ignore this switch 
  esac ;
  shift;
done;

if [ -z ${KWA} ];       then KWA=${DEF_KWA[@]} ; fi
if [ -z ${KWB} ];       then KWB=${DEF_KWB[@]} ; fi
if [ -z ${GIF_BASE} ];  then GIF_BASE=$PNG_BASE ; fi
#if [ "${_help}"=="1"];  then 
#               (_help); else
               (_make);
#fi
#==============================================================================#

unset _help ;
#==============================================================================#

