
oo="CATFILE";
##============================================================================##
pfs() { OUT=$(printf "%${2}s"|sed "s/ /${1}/g"); printf '%s' "$OUT" ;}
PRBR=$(pfs '=' 60 );
DABR=$(pfs '~' 60 );
boo() { printf "%s\n" "$PRBR" >> $oo ; }
doo() { printf "%s\n" "$DABR" >> $oo ; }
baa() { printf "%s\n" "$PRBR"        ; }
daa() { printf "%s\n" "$DABR"        ; }
##============================================================================##

FF_LIST=(`ls -Atr  $(find . $PWD | grep -e "/home/dac" ) | head -n 15 `);
printf "FF_LIST : \n" ;
printf "%s\n" ${FF_LIST[@]};
printf "\n" ;
ladd(){ ff=$1 ;
  gg=$(ls -la $ff --time-style='+%Y-%m%d-%H%M%S' | awk '{print $7": "$6}' )
  printf "%s" "$gg"
}
lada(){ ff=$1 ;
  gg=$(ls -la $ff --time-style='+%Y-%m%d-%H%M%S' | awk '{print $6}')
  printf "%s" "$gg"
}
loopy(){

	for ff in ${FF_LIST[@]};
	do
		printf "\n %s\n" "$PRBR" ;
		printf "  CATENATING FILE : %s (date: %s) \n" "$ff" "$(lada $ff)" ;
		printf " %s\n" "$DABR" ;
		printf "   here would execute: cat $ff >> $oo \n";
		printf " \t...\n \t...\n \t...\n %s\n" "$PRBR" ;

    cat $ff 
#		cat $ff >> $oo

	done

}
( loopy ) | tee -a $oo
##============================================================================##
