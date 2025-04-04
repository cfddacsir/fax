# TOP_LIMIT=100000
TOP_LIMIT=5

function pfs () { 
			 OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT;
	};

bu=$(pfs '__' 50)
br=$(pfs '==' 50)

alias pgstar=' ps -Af | grep starccm+ '
proc=(`ps -Af | grep starccm+ | grep -v "grep" | grep -v "python" | awk '{print $2}'`)
pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
# top -b -n ${TOP_LIMIT} $pp > $HOME/wwtop.txt 

function ptop(){ 
	printf "%s \n" $(pfs '==' 50)
	proc=(`pgstar | grep -v "grep" | grep -v "python" | awk '{print $2}'`)
	pp=$(for i in "${proc[@]}" ; do printf "%s " '-p ' $i ; done );
	top -b -n 1 $(for i in "${proc[@]}"; do printf "%s " '-p ' $i ; done ) # > $HOME/wwtop.txt 
	printf "%s \n" $(pfs '--' 50)
	free -h 
	printf "%s \n" $(pfs '__' 50)

}

( ptop ) >> $HOME/ptop 

# && ( free -h ) 
