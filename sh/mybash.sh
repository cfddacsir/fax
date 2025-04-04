#!/bin/bash
###########################################################

##  FILEINFO >============================================
FILEINFO=(
    'mybash'
    'mybasha.sh'
    'Daniel.Collins'
    'DAC'
    2022 02 15 1054 T
    );

#==========================================================
	DASH='~dac/sh/'
	MYSH="$HOME/sh/"
      	mybash="$HOME/sh/mybash.sh"
alias 	mybash=" . $mybash; printf \"loading %s\n \" $mybash "

###========================================================
#	PATH=$(cat $HOME/pathset.rc)
#export  PATH=${PATH}:${DASH}:${MYSH}
export  PATH=${PATH}:${DASH}

### FUNDAMENTAL VALUES ####################################
 NOW=$(date +%Y%m%d%-H%M%S);
 TICK=$(date +%Y%m%d-%H:%M:%S); TIC=$(date +%s );

###########################################################

###	BLOCK_A
##---------------------------------------------------------
    alias echo='echo -e ';
    alias echoe='echo -e ';
    alias eche='echo -e ';
    alias mv='mv -v';
    alias up="cd ..";
    alias wee='whoami; hostname; pwd; date; ls -tr1Ah $PWD | tail -n 10; df -ah . ';
    alias vab='vi ~dcollins/.bashrc';
    alias mobash='more ~dcollins/.bashrc | more ';
    alias vab='vi dcollins/sh/mybash.sh';
    alias mobash='	cat ~dcollins/mybash.sh | more ';
    alias MYSH='	cd  ${MYSH}; date; pwd; ls -latr *.sh | tail -n 10';
    alias sve=' .	${MYSH}zavsve.sh';
    alias sve=' .	${MYSH}/sve.sh';
    alias agg=' 	alias | grep ';
    alias le='less ';
    alias ge='gedit ';
    alias mo='more  ';
    alias pg='ps -Af | grep ';
    alias taff='tail -n 1000  -F -f  '
    alias tagg="tail -n 10000 -F -f \$(ls -tr *.log ) "
    alias ta1='tail -n 1';
    ta1='tail -n 1';
    alias he1='head -n 1';
    he1='head -n 1';
    alias cpz=' cp -vu  --no-preserve=timestamps '
    alias cpt=' cp -vf     --preserve=timestamps '
    alias cpr=' cp -vfpr   --preserve=timestamps '
    alias openmod=' chmod -Rv 777 ';
    alias mkdiropen=' mkdir -p -v -m=777 $1 ';
    alias mkdirdef='  mkdir -p -z        $1 ';
    alias his='  history ';
    alias hgg='  history 10000 | grep ';
    alias hisse="mkdir -p -m=755 $USER/hist && history 40 > $USER/hist";
    alias hisse=". ${MYSH}hisse.sh ";

#------#  FILE SEARCHING ##-----
    alias lt='   ls -1lh   ';
    alias lh="   ls -lAtrh ";
    alias lt='   ls -lAt   ';
    alias ltr="  ls -lAtr  "; ##  $ztsm           "
    alias la="   ls -lAtrh "; ##  $ztsm | awk $PQ "
    alias lk='   ls -lASh  ';
    alias lg='   ls -laR | grep             ';
    alias lsg='  ls -latR . | grep          ';
    alias luch=" ls -latR  $ztsm . | grep   ";
    alias seek='find $PWD | grep            ';
    alias recent=' ls -trlA1th ` find $PWD | grep $1 ` ';
    ##
#------#  SIZING ##------
    alias dfa='df -ah 	';
    alias duc='du -ch 	';
    alias duc1='du -ch -d 1 ';
    ##
#------# FILE UTILITIES  ##----------------------------------------------------
    alias pack='	 alias pack;  	gzip -Nqv6 -S .gz ';
    alias packmax='alias packmax;	gzip -Nqv9 -S .gz ';
    alias ark='		 alias ark; 	echo \" archivng file $1 \" ; tar -cvf $1; gzip -Nqv9 -S .gz $1.tar';
    alias unark='	 alias unark;	echo \"unpacking archive $1\"; tar -xvf $1; gzip -dv ${1#.tar}';
    alias unpack=' alias unpack;	echo \"unpacking gzip file $1 \"; gzip -dv $1 ';
    alias untar='	 alias untar;	echo \"extracting tar file $1 \"; tar -xvf ';
    alias mach='.  machines.sh';
    alias savepwd=" echo \" saving $PWD into ~/.pathrc \";  pwd  >> ~/.pathrc ";
    alias swd="     echo \" saving $PWD into ~/.pathrc \";  pwd  >> ~/.pathrc ; tail -n 1 ~/.pathrc";
    alias askpath='. ${DASH}/askpath.sh';
    alias asw=" 	 echo \" askpath \"; .  ${DASH}/askpath.sh";
    alias cwd='		 cat -n  ~/.pathrc | more';
    alias mpc='	 	 more ~/.pathrc | more ';  # alias available mpp, wpc...
    alias xkk=" .   ${MYSH}xkill.sh ";
    ##

    svf="$HOME/sh/svf.sh"
    alias svf=". $HOME/sh/svf.sh"
#------# APP ADMIN      ##----------------------------------------------------
    alias yums='yum search $1 | more ';
    alias yuma='yum list ';
    alias yumy='sudo yum install -y  ';

#------# COMPUTER LOADS #------#
    alias rtop='.  ${MYSH}rtop.sh';
    alias pg='		 ps -Af | grep ';
    alias awat='   w -u -o -i  ';
    alias fret='	 free -h -w -l -t 					';
    alias atop=' 	 top -b -d 1 -i -n 10 -o %CPU | head -n 30 ';
    alias wtop='   w -u -o -i  	 && top -b -d 1 -i -n 10 -o %CPU | head -n 30 ';
    alias ftop='   free -h -w -l -t  && top -b -d 1 -i -n 5  -o %MEM | head -n 12 ';
    ###
##---------------------------------------------------------

##=========================================================
##	MAIN
##---------------------------------------------------------
    ###	block_p
    ### block_a

    function suba (){
      unset BX;
      BX=(bashrx.sh bashrc.sh);
      echo -e "** Files to update: ${BX[@]} ** ";
      for w in ${BX[@]} ; do
        x=${MYSH}/${w} ;
        y=${HOME}/${w} ;
        echo -e " \t $w .... \n \t $x && $y ... " ;
        echo -e " \t ?  --- Replace ${y} with ${x} ...  " ;
        ls -latr $x $y ;
        cp -pv -i ${x} ${y};
      done;
    } ##
    #

##=========================================================
    ## more of my own /2022/02/15/...    
    saves='~/.saves/'
    alias saves=' mv -v $1 ~/.saves '
    
##---------------------------------------------------------
 



