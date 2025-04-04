slist=(/home/dac/sh /home/dac/starmac )
one=/home/dac/onedrive/NICKEL/home
for s in ${slist[@]}; do 
   X=$(printf "rsync -ravz $s $one"); 
   printf "$X\n" ; 
   eval $X; 
done

