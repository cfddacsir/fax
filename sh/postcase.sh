#============================================================
#Process simcase
#============================================================

  ls ~/starmac/proj_escpv/escpv_post.java
  DOJAVA=/home/dac/starmac/proj_escpv/escpv_post.java
  ls -latr *.sim
  printf 'enter the case you want to process, remove the .sim in name' ;
  read SIMCASE

  starccm -power -batch ${DOJAVA} ${SIMCASE}.sim >> ${SIMCASE}_report.txt 
  cat ${SIMCASE}_report.txt 

#============================================================

