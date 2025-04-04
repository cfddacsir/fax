
##########################################################
 ##  FILEINFO >============================================
 FILEINFO=(
    'bashlx.sh'
    2022 02 15 1117 T
    'Daniel.Collins'
    'DAC'
    );
##========================================================
 ME=${USER}; MEH=${HOME}

###========================================================
   function pfrep(){
     z=${1};
     r=${1};
     printf "{$z}%.s" {1..$r}
   }
   function pfdix(){
     z=${1};
     r=50;
     printf "{$z}%.s" {1..$r}
   }
   function tazz(){
     tail -n 1000 -F -f $(ls -tr $1 | tail -n 1)
   }
##----------------------------------------------------------
##	TIMESTAMPING
##----------------------------------------------------------
   alias now='NOW=$(date +%Y%m%d%H%M%S  ); echo "NOW=${NOW} " ';
   alias tt=' zt=$(date +%Y%m%d%H%M%S -u); echo $zt ';

   function pnow(){
    NOW=(`date +%Y%m%d_%H%M%S`);
    printf $now
   }

  function lazt(){
    # date +%m%d-%H%M
    # ls -la --time-style='+%Y%m%d-%H%M' $1
    zt=$( ls -la --time-style='+%Y%m%d-%H%M' $1 | awk '{print $6}' )
    printf $zt
  }
  function fnow(){
    now=(`date +%Y%m%d-%H%M%S`);
    printf $now
  }
  function ruk(){
    f=$1;  stmp=$( lazt ${1})
    cp -pv ${1} ${1}__${stmp}
  }
  function dup(){
    f=$1;  now=$(fnow);
    cp -pv ${1} ${1}__${now}
  }

##=========================================================
   function prdots() {
     printf "${1}%.s" $(seq 1 $2) ;
   }
   function pfsed() {
     OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;
   }
   function fdiv()  {
     E=$(($4 - $2)); ## example \# 2 \- 60 ##echo $E;A=$1;AA=$2;B=$3;C=$4;
     FDIV="$(printf "%${2}s"|sed "s/ /${1}/g")\
           $(printf "%${E}s"|sed "s/ /${3}/g")"  ;
     printf '%s' "$FDIV" ;
   }
   function hdiv() {
     dx=${1}; dy=$(fdiv \# 2 $dx 60); printf '%s\n' "$dy" ;
   }
