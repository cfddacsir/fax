#!/bin/bash
################################################################################

#==============================================================================#
# File Header Info
#-------------------------------------------------------------------------------
	FILENAME=$(basename $0); 
	FILEINFO=( 
  $(basename $0)
  'memorywatch.sh'
  'Daniel Collins' 'DAC' 
  'Daniel.Collins@enervenue.com'
	);
	VERSIONING=(
  '2022-09-20-s1224'
  '2022-09-30-s2121'
  '2022-10-09-S1006'

	);
#==========================================================
	ME=${USER} ; 
  MEH=${HOME};

#==========================================================
	[ -f  $HOME/STOP ] && ( rm -f $HOME/STOP ) 
	[ -f  $PWD/STOP  ] && ( rm -f $PWD/STOP  ) 

	rm -f $PWD/HOME
	rm -f $PWD/STOP

###========================================================
	DO_GM=0
	MEMOBASE=6
	DEF_LWAIT=4
	DEF_SWAIT=300
	WATCHLOG=$HOME/watchtop.txt ## $WATCHLOG
	MEMOWATCH=$HOME/memoryload.txt

#===============================================================================
# usage
	usage="
 ---------------------------------------------------------
 . memorywatch.sh s {looping interval} i {logging interval}
 ---------------------------------------------------------
 ";

###========================================================
	function pfs () { printf '%s' $(printf "%${2}s"|sed "s/ /${1}/g"); };
  pbr=$(pfs '~~' 30) ;
	PRBU=$(pfs '__' 50)
	PRBR=$(pfs '==' 50)

###========================================================
	function fnow(){
    now=(`date +%Y%m%d-%H%M%S`);
    printf $now
  };
###========================================================

## alias pgstar=' ps -Af | grep starccm+ '
	proc=(`ps -Af | grep starccm+ | \
			 grep -v "grep" | grep -v "python" | grep -v bash | \
       awk '{print $2}'`)
	pss=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );

function loo(){
	loo=$( ls -tr *.log*| tail -n 1 );
  printf $( ls -tr ${PWD}/*.log*| tail -n 1 );
}

function dloog(){
	dloog=$( ls -tr ${PWD}/*.log*| tail -n 1 );
  printf $dloog
}

function dloou(){
#	dloo=$( ls -tr *.log*| tail -n 1 );
  printf $(ls -tr $(find /data/ | grep -e '.log' ) | tail -n 1);	
}
function preramble(){

	printf "%s \n" $(pfs '==' 50)
  date 
  pwd
	printf "%s \n" $(pfs '==' 50)

}

function procon(){
  proc=(`ps -Af | grep starccm+ | \
			   grep -v "grep" | grep -v "python" | \
         awk '{print $2}'`)
  printf "${#proc[@]}"
}
function starproz(){
  proc=(`ps -Af | grep starccm+ | \
			   grep -v "grep" | grep -v "python" | \
         awk '{print $2}'`)
  printf "${proc[@]}"
}
getproz(){
	if [ "${1}" == "n" ]; then
		printf "%d" $(procon) 
	fi
	if [ "${1}" == "s" ]; then
	#  printf "%s" $(starproz)
		printf "%s " ${proc[@]}
	fi
	if [ -z ${1} ] ; then
		ptop 
	fi
}

ttop() {
      top -b -n 1 $pss |\
			head -n 8 | \
      grep -v top |\
      grep -v Tasks
}  

function mem_head(){ 
  mem_tophat=(` ttop | head -n 5 | grep -e 'Mem :'`)
  mem_total=${mem_tophat[4]}
  mem_free=${mem_tophat[5]}
  mem_used=${mem_tophat[7]}
  mem_avail=${mem_tophat[17]}
  mem_head=(`printf "%s %s %s %s" $mem_total $mem_free $mem_used $mem_avail`)
  printf "%s %s %s %s" $mem_total $mem_free $mem_used $mem_avail
}

function mem_used(){
  mem_head=$( mem_head );
# mem_used=${mem_head[2]};
  mem_used=$(printf "%s" $(mem_head | awk '{print $3}'))
  printf "%s" $mem_used ;
}

function mem_base(){
  mem_head=$( mem_head );
# mem_base=${mem_head[2]}
  mem_base=$(printf "$mem_head" | awk '{print $3}')
  printf "%s" $mem_base ;
}

function ptop(){ 
	printf "\n%s\n  »  MEMORY USAGE:  $(date -u +%s) | $(date) \n" $(pfs '__' 50)
  proc=(` ps -Af | grep -e "starccm+" | \
			    grep -v "grep" | grep -v "python" | \
          awk '{print $2}' | head -n 20 `)
	pss=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
  printf "  »   »  ";
	  ttop | head -n 1
  printf "  »   »  ";
	  ttop | head -n 2 | tail -n 1  
    u=$(mem_used)
    printf " net use: %d \n" $(echo "scale=4;$u-$mem_base"|bc -l) 
	printf "%s \n" $(pfs '__' 50)
  
}
function utop(){ 
  pbr=$(pfs '__' 40) ;
  pbr=$(pfs '~~' 40) ;
  pbr="";
  use=$(mem_used) ;
  net=$(echo "scale=4;$use-$mem_base"|bc -l) ;
#	printf "\n$pbr\n\t   » MEMORY: %4.1f /NET: %4.1f /EPOCH: $(date -u +%s) | $(date) «\n$pbr\n" $use $net;
	printf "    » MEMORY: %4.1f /NET: %4.1f /EPOCH: $(date -u +%s) | $(date) «\n" $use $net;
  
}
function loop_topper(){
  pbr=$(pfs '~~' 30) ;
	uctr=0;
  mem_base=$(mem_used); printf "base memory: $mem_base"
	while [ $(procon) -gt 0 ]; do
		uctr=$(( uctr + 1 ))
#      ( utop   )
			( utop   ) | tee -a $WATCHLOG
		if [ $(( uctr % LWAIT )) -eq 0 ]; then
			( utop   )  >> $(dloog) 
		fi
		if [ -f $HOME/STOP ]; then 
	 		printf "detected STOP\n"; break; 
		fi 
		if [ -f $PWD/STOP ]; then 
	 		printf "detected STOP\n"; break; 
		fi 
		sleep $SWAIT
		
	done
}
function close_watchtop(){
  mkdir -pv $HOME/log
	cp -pvf  $WATCHLOG $HOME/log/watchtop_$(fnow).txt
	ls -latr $WATCHLOG $HOME/log/watchtop_$(fnow).txt
	tail -n 100 $WATCHLOG
}

function getmemory(){
  MEMOBASE=6
  grep -e "Mem" | grep -ve 'Mem:' $( ls -tr $HOME/watchtop*.txt | tail -n 1) \
	| awk '{print $8 - 6}' > $HOME/memorywatch_$(fnow).txt
#	| awk '{print $3}' |awk -F 'G' '{print $1 - 6 }' > $HOME/memorywatch_$(fnow).txt
}

function getmemory_mo(){
    printf "doing (getmemory) and exiting \n"
    [ $DO_GM -eq 2 ] && ( getmemory ) ; 
    printf "last lines of memorywatch \n..................\n"
    tail -n 10 $( ls -tr $HOME/memorywatch*.txt | tail -n 1 ) 
}
    


##=========================================================
## OPTIONS
while [[ ${#@} -gt 0 ]] ; do
	key="${1}"
	case "$key" in 
   i)
 		shift;
    LWAIT=$1 
   ;;
	 s) 
 		shift;
    SWAIT=$1
   ;;
	 m) 
    DO_GM=1
   ;;
	 nom) 
    DO_GM=0
   ;;
	 mo) 
    DO_GM=2
   ;;
  esac;
  shift;
done
# =========================================================

##### if  [ -z "$LWAIT" ] || [ $LWAIT==0 ] ; then LWAIT=10000000   ; fi  #####
##### ## omitting now bc it was persisting overriding value for LWAIT
##### ## .. and therefore not triggering the subroutine.
##### if  [ -z "$SWAIT" ] || [ $SWAIT==0 ] ; then SWAIT=$DEF_SWAIT ; fi
printf " setting LWAIT interval: [cat>> sim.log] : ${LWAIT} \n"
printf " setting SWAIT interval: [loop ( ptop )] : ${SWAIT} \n"
# =========================================================

# =========================================================
#  Main
# --------------------------------------------------------
if [ $DO_GM -eq 2 ] ; then 
	( getmemory_mo ); 
else 
	( preramble ) > $WATCHLOG ;
	( loop_topper ) ;
  ( close_watchtop ) ;
 	[ $DO_GM -eq 1 ] && ( getmemory ) ;

fi;

rm -f $PWD/STOP
rm -f $HOME/STOP

################################################################################

