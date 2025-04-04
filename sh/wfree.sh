bu=$(pfs '__' 40)
br=$(pfs '==' 40)
loo=$(ls -tr *.log*|ta1);

vfree(){
	printf "%s \n" $(pfs '--' 40)
	free -h 
	printf "%s \n" $(pfs '__' 40)
}

vfree 
