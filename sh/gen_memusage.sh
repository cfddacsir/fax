
WATCHLOG=$(ls -tr watchtop.txt | tail -n1) ;
MEMOSUM='./memorysum.txt' ;
py_plot="$HUB/plot_memusage.py"
printf "Epoch(s), Total(GB), Used(GB) \n" > $MEMOSUM

head -n 10 $WATCHLOG

#grep -e 'MEMORY' $WATCHLOG | awk '{print $7", "$3", "$5"\n"}' >> $MEMOSUM
grep -e 'MEMORY' $WATCHLOG | awk '{print $7", "$3", "$5}' >> $MEMOSUM

python3 $py_plot 

eog ./memoryplot.png

