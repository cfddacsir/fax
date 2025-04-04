#!/bin/bash
#==========================================================
FILEINFO=(
	'setfav.sh'
	'Daniel.Collins@enervenue.com'
	'DAC'
	'2022-09-19-1554'
)
   DASH='~dac/sh/'
   MYSH="$HOME/sh/"
   fpath=$HOME/.pathrc

#==========================================================
##============================================================================##
##	HEADER

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
		current directory: $PWD >

		ENTER YOUR SELECITON 
			< empty space returns to current drive [$psel] >
		";
		read psel

		if [ -z $psel ]; then
			echo " your response was empty, returning to $curd"; 
      cd $curd; pwd;
		else
      pwf="${pch[$psel]}" ;
      printf "exporting pwf = $pwf = < $psel>  " ; 			
      export pwfav ;
		fi
	else 
		echo "error 101"
	fi
  printf "\n."
 
##============================================================================##
##	FOOTER / VERSIONING
##============================================================================##

