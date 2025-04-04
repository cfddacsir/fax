
##___ARGMENU ________________________________________________
while [[ $# -gt 0 ]] ; do key="${1}"
  case $key in 
    help|--h|-h)
	( printf " ${__doc__} ${__usage__} ${__version__} " );
	# skip_main=1 # True;
	# exec_main=0 # False;
	break ;;
    arg1)
	printf "set arg1 values"
    ;;	
esac; shift; done 
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ $skip_main ] ; printf "....." ; else
## exec_main ##
fi

############################################################# 
