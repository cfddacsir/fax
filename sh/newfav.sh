ls -dA1 $PWD/* > dir.list
for d in $(cat dir.list ); do
   ls -latrh ${d}/*.sim --time-style=long-iso | awk '{print "\t" $5"\t"$6"-"$7" \t "$8}'; 
done

