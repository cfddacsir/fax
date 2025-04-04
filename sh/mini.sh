beg=1020;
end=1042;
for hs in `seq $beg $end`
do
	printf "!%s == " "${hs}" ;
  history 150 | grep -e " ${hs}  " ;
  printf "\n" ;
  \!$hs 
done;

