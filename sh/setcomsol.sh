#!/bin/bash
#=============================================
FILEINFO=(
	'setcomsol.sh'
	'Daniel.Collins@enervenue.com'
	'2022-02-24-1208-T'
)
##export	DASH='~dac/sh/'
##export	MYSH="$HOME/sh/"
export  HUB='/home/common/sh'
export  DASH=$HUB  ### DASH='~dac/sh/'
export  MYSH="$HOME/sh/"
setcomsol="$DASH/setcomsol.sh"
alias 	setcomsol=" . $setcomsol; printf 'loading %s' $setcomsol"
###========================================================


    COMSOL_ROOT=/opt/comsol60/multiphysics
    COMSOL_BIN=/opt/comsol60/multiphysics/bin/
    export PATH=$PATH:$COMSOL_BIN

    alias comsol=/opt/comsol60/multiphysics/bin/comsol 
    alias comsol60=/opt/comsol60/multiphysics/bin/comsol 

COMSOL_LICBIN=/opt/comsol60/multiphysics/license/glnxa64/
COMSOL_LICDAT=/opt/comsol60/multiphysics/license/license.dat
COMSOL_VARLOG=/home/common/lic/comsol60.log

alias comlic="
    sudo   ${COMSOL_LICBIN}/lmgrd -c ${COMSOL_LICDAT} -l $COMSOL_VARLOG
" 
    export PATH=${PATH}:${COMSOL_BIN}:${COMSOL_LICBIN}
    export LM_LICENSE_FILE=$COMSOL_LICDAT
    
alias tvar="
    echo $COMSOL_VARLOG
    tail -n 100 -F -f $COMSOL_VARLOG
    "
alias lmcomsol="lmutil lmstat -a -c $COMSOL_LICDAT"

alias loadcom=". setcomsol.sh; echo $COMSOL_LICDAT; lmcomsol"

##---------------------------------------------------------
