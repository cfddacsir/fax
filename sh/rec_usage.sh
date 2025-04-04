recusage(){ 
  B=${1}
	if -z ${B}; then E=$(pwd); fi
	D=$(date);
	U="$HOME/usage.txt"


echo '' >$U
sh > $U << EOF
printf "##BASE: $B \n" 
printf "##DATE: $D \n"
# du -ch -d 1 $BASE 
EOF

}
# recusage ${1}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
#  Getting Option values from Input Arguments
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#      
DEF_BASEDIR=$(pwd);
  while [[ ${#@} -gt 0 ]] ; do key="${1}" ; 
	case "$key" in 
	  -b  )  shift; BASEDIR=$1 
              if [ -z $BASEDIR ];then BASEDIR=$DEF_BASEDIR;fi 
      ;;
      -h|--h|--help) cmdhelp="h"; break ;
      ;;
    esac 
  shift
  done ;
  if [[ "${cmdhelp}" == "h" ]] ; then
     printf "${_usage}" ; (showrev) ;
  else
    if [ -z $BASEDIR ];then BASEDIR=$DEF_BASEDIR;fi 
  printf "
 ¨¨¨¨¨ Executing recusage with baseddir = %s \n at: \t $(date +%s) $(date +%Y%m%d-%H%M) \n
 ¨¨¨¨¨ \n" \
       "${BASEDIR}" ;
     ( recusage ${BASEDIR} );
  fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#