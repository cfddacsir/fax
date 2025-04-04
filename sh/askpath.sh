#!/bin/bash
#==========================================================
FILEINFO=(
	'askpath.sh'
	'Daniel.Collins@enervenue.com'
	'DAC'
	'2022-02-14-1425'
)
   DASH='~dac/sh/'
   MYSH="$HOME/sh/"
   fpath=$HOME/.pathrc

#==========================================================
##============================================================================##
##	HEADER

function sheader(){
	sf=$(basename $0 )
	now=$(date +%Y-%m-%d--%H%M ); 
#	echo -e " " #	
	}; [ $1=="--sh" ] && ( sheader )
#	sheader;
##	//END: header :------------------------------------------------------------

printf "    .................................................
    prompts what pathway to goto based on 
    list of directories stored in [$fpath] 
    ................................................. "

##==============================================================================
	curd=`pwd`
	unset pch

        pch=(`cat ${fpath} `)
	nn=${#pch[@]}

	if [ -n ${pch} ]; then	jx=0;

		echo -e "
		You have [ ${#pch[@]} ] choices. Now listing the choices as: \n"
			printf "\t [%3s]  =  %-s \n\n" "option work_path"

		for ix in `seq 0 $(( ${#pch[@]} - 1)) `; do
			printf "\t [%3s]  =  %-s \n" $ix ${pch[$ix]}
		done
		echo -e "
		time now is: $now >:
		current directory: $PWD >

		ENTER YOUR SELECITON 
			< empty space returns to current drive [$curd] >
		";
		read CHP

		if [ -z $CHP ]; then
			echo " your response was empty, returning to $curd"; cd $curd; pwd;
		else
			echo " you selected $CHP = ${pch[$CHP]} "
			cd ${pch[$CHP]}
		fi
		pwd
	else 
		echo "error 101"
		#return(1); break;
	fi



##============================================================================##
##	FOOTER / VERSIONING
##============================================================================##

