printf '' > dot_list ;

ark="$HOME/nickel_home_dac_dotdir.tar";
alias seek=' find $PWD | grep $1 ' ;

dotf() { ls -ltrAd1 $HOME/.* | grep -v root | grep -e 'dr' | head -n 35 | awk '{print $9}' ; }
AA=(`(printf "%s\n" $(dotf |  head -n $(( $( dotf | wc -l ) - 1)) ))`)

make_list(){
for df in ${AA[@]}; do 
  #printf "%s\n\%s\n" "$DARBR" $df ; 
#	cd $df; 
	find $df 
done 

}

(make_list) >> dot_list ;

for ww in $(make_list); do
printf "\n tar -cvf $ark $ww ";
           tar -cvf $ark $ww  ;

done

