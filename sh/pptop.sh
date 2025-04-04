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
function starproz(){

  proc=(`ps -Af | grep starccm+ | \
			   grep -v "grep" | grep -v "python" | \
         awk '{print $2}'`)
  printf "${proc[@]}"
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
