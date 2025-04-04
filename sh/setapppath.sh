
app_rep=$HOME/sh/apps.sh
app_rep=$HOME/.path_apps.rc
app_rep=$HOME/.pathrc_apps

function setapp(){
  
  printf "name of app :";
  read aname 

  printf "path of app :";
  read apath 

  ## confirming existence 
  te=$(ls "$apath" );
  if [ -f "$apath" ]; then  
  ## printf "alias %s=\"%s\" \n " $aname (ls "apath") | tee -a $app_rep ;
  printf " alias ${aname}='%s' \n " "$apath" | tee -a $app_rep ;
  printf " \n";
  fi

}


