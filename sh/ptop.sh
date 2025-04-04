# TOP_LIMIT=100000
TOP_LIMIT=5

function pfs () { 
			 OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT;
	};

bu=$(pfs '__' 50)
br=$(pfs '==' 50)

alias pgstar=' ps -Af | grep starccm+ '
proc=(`ps -Af | grep starccm+ | \
			 grep -v "grep" | grep -v "python" | grep -v bash | \
       awk '{print $2}'`)
pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
# top -b -n ${TOP_LIMIT} $pp > $HOME/wwtop.txt 

function ptop(){ 
	printf "%s \n" $(pfs '==' 50)
  proc=(`ps -Af | grep starccm+ | \
			   grep -v "grep" | grep -v "python" | \
         awk '{print $2}'`)
	pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
	top -b -n 1 $(for i in "${proc[@]}"; do printf "%s " '-p ' $i ; done ) # > $HOME/wwtop.txt 
	printf "%s \n" $(pfs '--' 50)
	free -h 
	printf "%s \n" $(pfs '__' 50)

}

#while [ -z $(ls $HOME/STOP) ]; do
while [ ! -a "$HOME/STOP" ]; do
	( ptop )  # >> $HOME/watchtop 
  sleep 15
  if [ -a "$HOME/STOP" ]; then 
 		printf "detected STOP"; break; fi 
done

