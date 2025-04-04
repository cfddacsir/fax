#==============================================================================#
  ## setpath.sh
  Catpath(){
    f=${1}; i=0;
    for p in `cat ${f} `;do
      q=${p:0:1}
      if [ "$q" != "#" ]; then
        if [ $i -gt 0 ]; then printf ":"; fi 
        printf "%s" $p; 
      fi;
      i=$((i+1));
    done
  };
  # PYTHONPATH:
  RC_ENV_PATH=$HOME/rc/paths/
  PYTHONPATH=$( Catpath ${RC_ENV_PATH}/PYTHONPATH )
  printf "PYTHONPATH=%s \n" $PYTHONPATH

#==============================================================================#
