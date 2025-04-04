#!/bin/bash

###########################################################
  reinsim(){ #~~~ [ reinsim() ] ~~~~~~~~~~~~~~~~~~~~~~~~~##
    RDD=spp
    LDD=loo
    latest(){ #~~~ [latest() ]
      latest=$(ls -tr $(find . | grep -i -e $1 ) | tail -n1 ); 
      printf "${latest}" ;
    } 
    copylast(){ #~~~ [copylast() ]
      kwend=$1 ;
      # kwext=$2 ; 
      lastfull=$( latest $kwlast ) ;
      last=$( basename -a ${lastfull} ) ;
      if [ -n ${lastfull} ] ; then
        cp -vfu --preserve=time ${lastfull} spp/${last%%.$kwend} ;
      fi
    }
    ls -latr ;
    ls -latr  *run* *log* *png* ;
    mkdir -p  $RDD; mkdir -p $LDD; 
    rm -fv    STOP ;
    mv -v     *png $RDD/ ;
    mv -v     *run* *log* *STAR *MESHGEN memory* watchtop* *txt $LDD ;
    mv -v     rulo/* $LDD/. ;
    mv -v     $LDD/  $RDD/. ;
    du -cah   *.sim* ;
    du -cah -d 0 . ;
    rm -fv    *.sim~ ;
    du -cah   *.sim  ;
    ls -latrh        ;
    copylast "runstat.txt" ;
    copylast "post.log"    ;
  }  #~~~#~~~ [ reinsim ] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~##
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
###########################################################

