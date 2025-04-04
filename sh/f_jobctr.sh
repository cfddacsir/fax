#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#==============================================================================#
	function jobctr() {
	  cjob="$HOME/BATJOBS/JCTR" ;
	  mkdir -m=754 ${cjob} ;
	  npjobs=$( ls -tA ${cjob} | wc -l ) ; 

    xjob=$((  npjobs + 1))
	  echo ${npjobs} ;
	  echo ${xjob}   ;
	  vjob=$( ls -tA ${cjob}| head -n 1) ; 
#	  printf "\tLAST job nr : ${vjob} \n\tTHIS job nr : ${xjob} \n" ;

	  if [ ${xjob} -lt 1 ];       then QJOB="0000${xjob}"; else
	   if [ ${xjob} -lt 10 ];      then QJOB="000${xjob}"; else
	    if [ ${xjob} -lt 100 ];     then QJOB="00${xjob}"; else
	     if [ ${xjob} -lt 1000 ];    then QJOB="0${xjob}";
	     fi
	    fi 
	   fi
	  fi
	  TJOB="${cjob}/${QJOB}" ;
	  touch ${TJOB} ;
#    printf "reviewing last couple assigned jobs \n" ;
	  ls -lAtr ${cjob}  |tail -n 3 ;
    export    QJOB   ;
    printf "${QJOB}" ;
  }
#==============================================================================#
 ( jobctr ) ;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
