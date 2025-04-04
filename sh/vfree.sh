bu=$(pfs '__' 40)
br=$(pfs '==' 40)

floo=$HOME/freetop.log 
loo=$(ls -tr *.log*|ta1);
dloo=$(ls -tr $(find /data/ | grep -e '.log' ) | tail -n 1);	

vfree(){
	printf "%s \n" $(pfs '--' 40)
        date 
	free -h 
	printf "%s \n" $(pfs '__' 40)
}

vfree >> $(loo);
# tail -n 10 $(loo);

vfree >> $floo ;
tail -n 10 $floo;

