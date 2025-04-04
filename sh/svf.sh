#!/bin/bash
export SVIN=(backer.sh 1409 16 08 2020 U-0700);
export SVKN=('Daniel_A_Collins' 'DAC' 'dacdynamics@gmail.com');
unset PH os af
def_os=mac;
NOW=$(date +%Y%m%d%-H%M%S);
###########################################################



####===================================================####
  ### PATHS ##--------------------------------------##
  favoritepaths(){
    MYSH=${HOME}/sh/
    sush=${HOME}/sh/
    PATH=$PATH:${sush}
    icloud='/Users/dac/Library/Mobile Documents/com~apple~CloudDocs/'
    user_lib="${HOME}/Library"
    mobdoc='Mobile Documents'
    appicd="com~apple~CloudDocs"
    ic=$(printf "\'%s/%s/%s\'" ${user_lib} "${mobdoc}" ${appicd})

    SS=(MYSH sush PATH icloud user_lib mobdoc appicd ic)
    SV=($MYSH $sush $PATH $icloud $user_lib $mobdoc $appicd $ic)
    printf "\n%s ~= \t%s \f" ${SS[@]} ${SV[@]}
  }
###########################################################


###========================================================
 ##
  function v_lin() {
  zt=`date +%Y-%m-%d-UT%H-%M-%S -u `;  #// in Std Univ Time UTC/Zulu
  #  echo "ZULU TIME STAMP  zt=$zt "
  yt=`date +%Y-%m-%d-LT%H-%M-%S `;     #// Localised Time
  #  echo "LOCAL TIME STAMP yt=$yt "
  # fa=$1;
  fa=$af
  echo -e "\t\t file to backup is:	$fa "
  YR=` ls -lA1 --time-style=long-iso $fa | awk '{print $7}' | awk -F '-' '{print $1}' `
  MON=`ls -lA1 --time-style=long-iso $fa | awk '{print $7}' | awk -F '-' '{print $2}' `
  DAY=`ls -lA1 --time-style=long-iso $fa | awk '{print $7}' | awk -F '-' '{print $3}' `
  HR=` ls -lA1 --time-style=long-iso $fa | awk '{print $8}' | awk -F ':' '{print $1}' `
  MIN=`ls -lA1 --time-style=long-iso $fa | awk '{print $8}' | awk -F ':' '{print $2}' `
  ft="${YR}${MON}${DAY}-${HR}${MIN}";     ## time stamp of file from ls
  fb="${fa}-sv${ft}"

  echo -e "\t\t $zt: ZULU  time archiving $fa to $fb " ; \
  echo -e "\t\t $yt: LOCAL time archiving $fa to $fb " ; \

  cp -vfu --preserve=timestamps $fa $fb
  echo -e "\t\t showing the former and latter..."
  echo -e "\t\t done"
  }
###########################################################


###========================================================
 ##
  function v_mac(){
    zt=`date +%Y-%m-%d-UT%H-%M-%S `;  #// in Std Univ Time UTC/Zulu
	 #  ##  echo "ZULU TIME STAMP  zt=$zt "
    yt=`date +%Y-%m-%d-LT%H-%M-%S `;     #// Localised Time
	 #  ##  echo "LOCAL TIME STAMP yt=$yt "
   fa=$af;
   printf "\b   File to backup is: \n\b	....... $fa \n"
   YR=`  stat -l -t '%F %T' $fa | awk '{print $6}' | awk -F '-' '{print $1}' `;
   MON=` stat -l -t '%F %T' $fa | awk '{print $6}' | awk -F '-' '{print $2}' `;
   DAY=` stat -l -t '%F %T' $fa | awk '{print $6}' | awk -F '-' '{print $3}' `;
   HR=`  stat -l -t '%F %T' $fa | awk '{print $7}' | awk -F ':' '{print $1}' `;
   MIN=` stat -l -t '%F %T' $fa | awk '{print $7}' | awk -F ':' '{print $2}' `;
   ft="${YR}${MON}${DAY}-${HR}${MIN}";     ## time stamp of file from ls
   fb="${fa}-sv${ft}";
   # echo "$zt: ZULU  time archiving $fa to $fb " ; \
   # echo "$yt: LOCAL time archiving $fa to $fb " ; \
   printf "\t\t\b (now copying....) \n";
   cp -f -v -p $fa $fb;
   printf "\b   Showing the former and latter... \n\n";
   ls -la $fa $fb;
  }
###########################################################

##=========================================================
  function getMach(){
  	## determine the o/s: macosx, linux, etc
  	printf "WIP"
  } ### EO function getMach
###########################################################

###========================================================
function getf(){
  ltf=`ls -tr | tail -n 1`;
  printf "
     No File was specified in arguments.
     Choose option ....
     *|0) save version on last file <$ltf>
       2) list files to choose
  "; read aopt
   case $aopt in
     2)
      pwd
      ls -ltr1A $PWD/*.*
   printf "*** Choose which file to save."
      read taf;
      if [ -z $taf ]; then af=$ltf; else af=taf; fi ;;
     0|*) echo -e " .. using last file <$ltf> ";
      af=$ltf;;
    esac
  os=$def_os;
  export os af;
}
###########################################################

###========================================================
 ### GETTING ARGUMENTS
  if    [[ $# -eq 1 ]] ; then af="$1"; fi
  while [[ $# -gt 0 ]] ; do
    key="${1}"
     case $key in
        -V) PH=1;;
       -os) shift; os="$1"  ;;
        -f) shift; af="$1"  ;;
     esac
    shift
  done;
  if [ -z $af ]; then getf; fi
  if [ -z $os ]; then os=$def_os; fi
###########################################################

###========================================================
 ##case "${$os}" in
 printf " -> Reviewing Values ...\n"
 printf " -->> %s: %s <<- \n" "FILE TO BE BACKED:" $af "os" $os
 # echo ""
 case "$os" in
    lin)
      printf " Doing function v_$os ---> \n";
      v_lin $af  ;;
    mac|def_os|Darwin|*)
      os=mac;
      printf " Doing function v_$os ---> \n";
      v_mac $af  ;;
 esac
###########################################################


### ENDING ================================================
if [[ -n $PH ]] ; then printf \
 "\f\t\tEnding... Header:\f";PRHEADER;printf "$SHEADER";fi
printf "\nDONE: ${SVIN[0]}, $(date +%Y%m%d-%H:%M:%S).";echo
###<<<ENDOFSCRIPT=====================================<<<<<
###########################################################
