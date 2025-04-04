  export trail=$HOME/trail.txt
  alias  tell=" . $HUB/trail.sh" 

  ba=$(prrep '==' 40)
  be=$(prrep '==' 40)
  bc=$(prrep '..' 40)
  bu=$(prrep '__' 40)
  bn=$(prrep '~~' 40)
  bp=$(prrep '##' 40)
  bs=$(prrep '//' 40)


  printf "
  $be \n $(date ) \n $bc \n 
  $(ls -laA1 -tr $PWD/* ) 
  $bu
  " >> ~/trail.txt
  tail -n 10 ~/trail.txt
 
