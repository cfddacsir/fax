#!/bin/bash
# calc_stardur.sh

################################################################################
_info="
#===============================================================================
 FILENAME: calc_stardur.sh
 AUTHOR:   Daniel Collins, <Daniel.Collins@enervenue.com> [DAC]

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
_svn=( $(printf "%s" "${_info}") 
 2022-0909-9999t
 2023-0124-1046u
); _rev=$(printf ${_svn[$((${#_svn[*]}-1))]} ) ;

#==============================================================================#

################################################################################
pp(){ printf "$1%.s" $(seq 1 $2) ; }
PRBR=$(pp '=' 60 );
loo() {
     loo=$(ls -tr *.log* | tail -n1);
	   printf $loo;
};
calc_stardur() {
  
  BEG_STAR=${1} ;
  END_STAR=${2} ;
	printf "%s\n" "$PRBR" 

	#BEG_STARLONG=`ls -la --time-style=long-iso $BEG_STAR |awk '{print $6 }'`
	BEG_LONG=`ls -la --time-style='+%Y%m%d-%H%M%S' $BEG_STAR |awk '{print $6 }'`
	END_LONG=`ls -la --time-style='+%Y%m%d-%H%M%S' $BEG_STAR |awk '{print $6 }'`

	BEG_STAR=`ls -la --time-style='+%s' $BEG_STAR | awk '{print $6 }'`
	END_STAR=`ls -la --time-style='+%s' $END_STAR | awk '{print $6 }'`
	DUR_STAR=$(echo "scale=0;  ($END_STAR - $BEG_STAR)" | bc -l );
	DURSEG=` echo "scale=0; 
	(  $END_STAR - $BEG_STAR) / 3600
	(( $END_STAR - $BEG_STAR) % 3600) / 60
	(( $END_STAR - $BEG_STAR) % 3600) % 60" | bc -l `

	printf "
#  BEG_STAR: %d (sec) %s
#  END_STAR: %d (sec) %s
#  DUR_STAR: %d (sec) " $BEG_STAR $BEG_LONG $END_STAR $END_LONG $DUR_STAR 
# printf "\n%14s %4d ° %2d\'  %2d\" " ' ' ${DURSEG[@]}
  printf "%5s%4dh %2dm %2ds " ' ' ${DURSEG[@]}

	printf "\n%s\n" "$PRBR" 

}

##============================================================================##
## OPTIONS
while [[ ${#@} -gt 0 ]] ; do
	key="${1}"
	case "$key" in 
   mesh) shift;
    STAROPT="MESH"; 
    BEG_STAR="BEG_MESHGEN" 
    END_STAR="END_MESHGEN" 
    calc_stardur $BEG_STAR $END_STAR | tee -a $(loo) 
   ;;
	 run) shift;
    STAROPT="RUN"
    BEG_STAR="BEG_RUNSTAR" 
    END_STAR="END_RUNSTAR" 
    calc_stardur $BEG_STAR $END_STAR | tee -a $(loo) 
   ;;
  esac;
  shift;
done

##============================================================================##
## calc_stardur $STAROPT | tee -a $(loo)
################################################################################

