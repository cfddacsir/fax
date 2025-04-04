#!/bin/bash
# calc_meshgenduration.sh

# ls -la --time-style='+%s' BEG_MESHGEN END_MESHGEN | awk '{print $7": " $6 " (sec) (epoch)" }' >> $(loo)

loo() {
     loo=$(ls -tr *.log*|ta1);
	   printf $loo;
};
calc_meshdur(){
	printf "%s" "$PRBR" 

	BEG_MESHGEN=`ls -la --time-style='+%s' BEG_MESHGEN | awk '{print $6 }'`
	END_MESHGEN=`ls -la --time-style='+%s' END_MESHGEN | awk '{print $6 }'`
	DUR_MESHGEN=$(echo "scale=0;  ($END_MESHGEN - $BEG_MESHGEN)"    | bc -l );
	DUR_MESHMIN=$(echo "scale=10; ($END_MESHGEN - $BEG_MESHGEN)/60" | bc -l );

	GENSEG=` echo "scale=0; 
	(  $END_MESHGEN - $BEG_MESHGEN) / 3600
	(( $END_MESHGEN - $BEG_MESHGEN) % 3600) / 60
	(( $END_MESHGEN - $BEG_MESHGEN) % 3600) % 60" | bc -l `

	printf "
  BEG_MESHGEN: %d (sec)
  END_MESHGEN: %d (sec)
  DUR_MESHGEN: %d (sec) " $BEG_MESHGEN $END_MESHGEN $DUR_MESHGEN 
  printf "\n%14s %4d ° %2d\'  %2d\" " ' ' ${GENSEG[@]}
  printf "\n%14s %4d h %2d m %2d s  " ' ' ${GENSEG[@]}

	printf "\n%s\n" "$PRBR" 

#	printf "%s\n" "$DABR" 


}

calc_meshdur | tee -a $(loo)
