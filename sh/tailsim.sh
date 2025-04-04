  tailsim(){ ## 
   simpath=${1} ;
   if [ -z ${1} ]; then simpath=${PWD}; fi
   lastsim=$(ls -tr ${simpath}/*.sim|grep -v .gz|tail -n1 ) ;
   simcase=$( basename -a ${lastsim%%.sim} ) ; 
   simlog=$(ls -tr ${simpath}/${simcase}*log|tail -n1);
   xterm -title "TAILING CASE : ${simcase}" \
   -geom 480x40 -bg black -fg green \
   -e " tail --retry -n 1000 -f -F ${simlog} " &
  } ##eof ~~~ tailsim ~~~ ##

  
