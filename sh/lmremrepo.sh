#!/bin/bash
#==========================================================
FILEINFO=(
	'lmrema.sh'
	'Daniel.Collins@enervenue.com'
	'2022-03-31-1403-S'
);
  VERSE=(
	''
);
# ARG=${1};  ### detecting "quiet mode"
#==========================================================

PRBR=$(prrep '=' 60); 
export  HUB='/home/common/sh';

#==========================================================

 . /home/common/sh/setstar.sh q ;
 alias lmstar='lmstat -a -c /home/common/lic/starlicense.dat' ;

 function lmstar() {
  lmutil lmstat -a -c /home/common/lic/starlicense.dat;
	};

 function lmrema(){

   lmstar | grep -e "Users of ccmppower:" -A 7 | grep -v server_id | grep -e ":"
   R=$(
   lmstar | grep -e "Users of ccmppower:" -A 7 \
			    | grep -v -e "server_id " | grep -e ":" | grep -e "start"  \
					| awk '{print $6}' 			  | awk -F ')' '{print $1}'  
      );
   echo $R ;
	 lmutil lmremove -c $LICDAT_STAR -h ccmppower $NICKELIP 1999 $R ;
   lmstar  ;
 }
 lmstar;
 lmrema;

 
###--------------------------------------------------------

