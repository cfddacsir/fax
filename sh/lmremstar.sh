#!/bin/bash
#==========================================================
FILEINFO=(
	'lmremstar.sh'
	'Daniel.Collins@enervenue.com'
	'2022-03-31-1421-S'
);
  VERSE=(
	''
);
# ARG=${1};  ### detecting "quiet mode"
#==========================================================
function prrep() {
     OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' $OUT ;
};
PRBR=$(prrep '=' 60); 
export  HUB='/home/common/sh';

#==========================================================
 
 . /home/common/sh/setstar.sh q
 alias lmstar='lmutil lmstat -a -c /home/common/lic/starlicense.dat'
 KW="Users of ccmppower:"
 #function lmstar() {
 # lmutil lmstat -a -c /home/common/lic/starlicense.dat;
 #	}

 lmrema(){
 KW="Users of ccmppower:"
   lmstar | grep -e "Users of ccmppower:" -A 7 | grep -v server_id | grep -e ":"
   R=$(
   lmstar | grep -e "Users of ccmppower:" -A 7 \
			    | grep -v -e "server_id " | grep -e ":" | grep -e "start"  \
					| awk '{print $6}' 			  | awk -F ')' '{print $1}'  
      );
   printf "instance to be remove: %s \n" $R ;
	 lmutil lmremove -c $LICDAT_STAR -h ccmppower $NICKELIP 1999 $R ;
   lmstar | grep $KW -A 10 ;
 }
 lmstar | grep -e 'Users of ccmppower:' -A 10;
 lmrema;

 alias looplm=' watch -n 120 lmrema.sh '
 
###--------------------------------------------------------

