function gethostip(){
	HOSTIPF=$(ip a | grep -e "state UP" -A 5 | grep -e "inet " | awk '{print $2}' )
	HOSTIP=${HOSTIPF/%\/22}
	HOSTIP=${HOSTIPF/%\/22}; #echo $HOSTIP
	export HOSTIP 
	printf $HOSTIP
}
HOSTIP=$(gethostip);
export HOSTIP 
printf $HOSTIP

