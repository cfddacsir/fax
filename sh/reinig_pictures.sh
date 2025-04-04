###  reinig_pictures.sh
###  cleanup ~/Pictures by removing files containing KW

KW="Screenshot from 2022-07-21"
KW="Screenshot from 2022-08-09"
TU=''
DB=''


WT=$(ls . | grep -e "$KW" | wc -l ) 
IW=0;
RW=$WT;
while [ $(ls . | grep -e "$KW" | wc -l ) -gt 1 ]; do
   IW=$(( IW + 1 ))
   RW=$(( RW - 1 ))
   PC=$( echo "scale=4; $IW / $WT * 10000 " | bc -l )
   p=$(ls . | grep -e "$KW" | head -n 1 )
   
   [ "$DB"==1 ] && (
   printf "\n removing file \"$p\" $(ls -la "$p") "
   )
   [ "$TU"==1 ] && (
     rm -fv "$p"
   )

   if [ $(( PC % 10 ))=0 ] ; then
     printf " completed $PC "
   fi

done
