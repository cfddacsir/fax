#==============================================================================#
  HINTS=${HOME}/hints.txt
  Catsel(){
    f=${1}
    lines=($(wc -l $f))
    #printf "number of lines in $f: %s \n" $lines
    for i in `seq 1 $((lines+0))`; do 
      row=$(head -n $((i )) $f | tail -n 1);
      printf "\n%d \t: %s" $i "${row}";
      done
    printf "\n"
  }
  getrow(){
    i=${1};
    row=$(head -n $i $f | tail -n 1);
    printf "${row}"
  }
  selrow(){
    #printf "\n enter the selection nr"
    read -p " Enter the selection nr: " nsel;
    printf "$nsel"
  }
  execrow_test(){
    x=$(cat ~/test)
    printf "${x[@]}"
    eval  $x 
  }
  execrow(){
    eval  $x 
  }
  #while [$sel]{
  Catsel $HINTS ;
  nsel=` selrow  `;
  printf "selected: $nsel \n\n" 
  act=$( getrow $nsel)
  printf "retrieving ....\n"
  printf "${act[@]}"
  printf "\n\n"
  sleep -n 2;
  #printf "execute ?";
  eval "${act}"
#==============================================================================#
