lmrema(){
  KW='Users of ccmppower:'
  lmstar | grep -e 'Users of ccmppower:' -A 7 | grep -v server_id | grep -e ":"
  R=$(
  lmstar | grep -e 'Users of ccmppower:' -A 7 \
			    | grep -v -e "server_id " | grep -e ":" | grep -e "start"  \
					| awk '{print $6}' 			  | awk -F ')' '{print $1}'  
      );

  lmstar | grep -e $HOSTNAME;  ## #lmstar | grep -e "$KW" -A 10  
  printf "\n  instance to be remove: %s \n\n " $R ;
	lmutil lmremove -c $LICDAT_STAR -h ccmppower $NICKELIP 1999 $R ;
  lmstar | grep -e $HOSTNAME;  ## #lmstar | grep -e "$KW" -A 10 
}

