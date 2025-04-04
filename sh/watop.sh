
TOP_LIMIT=1
SINTER=10
SLEEPER=30
function pfs () { 
			 OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT;
	};
bu=$(pfs '__' 50)
br=$(pfs '==' 50)

function fnow(){
    now=(`date +%Y%m%d-%H%M%S`);
    printf $now
  };

## alias pgstar=' ps -Af | grep starccm+ '
proc=(`ps -Af | grep starccm+ | \
			 grep -v "grep" | grep -v "python" | grep -v bash | \
       awk '{print $2}'`)
pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );

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

function ptop(){ 
	printf "%s \n" $(pfs '==' 50)
  date 
  proc=(`ps -Af | grep starccm+ | \
			   grep -v "grep" | grep -v "python" | \
         awk '{print $2}'`)
	pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
	top -b -n 1 $pp |\
			head -n 12 | \
      grep -v top |\
      grep -v Tasks 

	printf "%s \n" $(pfs '--' 50)
	free -h 
	printf "%s \n" $(pfs '__' 50)

}


( preramble ) > $HOME/watchtop.txt

function whwhat(){
	uctr=0;
	while [ ! -a "$HOME/STOP" ]; do
		uctr=$(( uctr + 1 ))
			( ptop )  >> $HOME/watchtop.txt
		sleep $SLEEPER
		if ( $(( uctr % SINTER )) -eq 0 ); then
			( date )  >> $(loo) 
			( ptop )  >> $(loo) 
		fi
		if ( -a ./STOP ) || (( -a "$HOME/STOP" )) ; then 
	 		printf "detected STOP"; break; 
		fi 
		
	done
}

function wphat(){
	uctr=0;
	while [ $(. pptop.sh n) -gt 0 ]; do
		uctr=$(( uctr + 1 ))
			( ptop )  | tee -a $HOME/watchtop.txt
		sleep $SLEEPER
		if [ $(( uctr % SINTER )) -eq 0 ]; then
#			( date )  >> $(loo) 
			( ptop )  >> $(loo) 
		fi
		if [ [ -f "$PWD/STOP" ] ]; then 
	 		printf "detected STOP"; break; 
		fi 
		
	done
}
function close_watchtop(){
	cp -pvf  $HOME/watchtop.txt $HOME/watchtop_$(fnow).txt
	ls -latr $HOME/watchtop.txt $HOME/watchtop_$(fnow).txt
	cp -pvf  $HOME/watchtop.txt $HOME/watchtop_$(fnow).txt ./
	tail -n 100 $HOME/watchtop.txt
}

wphat
close_watchtop

