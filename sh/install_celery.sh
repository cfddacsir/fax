 
pyin_(){
    ex="     python3 -m pip install ${1} | tee -ai  ~/pip_install.log "
    printf "\n $ex \n "  ;
    if [ "$2" == "-q" ]; then printf "\t .\n"; else
      printf "now running ";
      printf  "#pyinstall ${1} " | tee -ai  ~/pyinstall.list.txt
      eval $ex ;
    fi
 }
 pyinstall(){
    printf "\n Now installing ${1} \n\n";
    if [ ${2}=="cf" ]; then cc="-c conda-forge"; printf "\t... will use conda-forge \n\n" ; fi;

    echo "#pyinstall ${1} " >> ~/pyinstall.list.txt
    python3 -m pip install ${1} | tee -ai  ~/pip_install.log

    echo "#conda install -y ${1} ${cc} | tee -ai  ~/conda_install.log " >> ~/pyinstall.list.txt
    conda install -y ${1} ${cc} | tee -ai  ~/conda_install.log
}

install_1(){
pip install https://github.com/celery/celery/zipball/main#egg=celery
pip install https://github.com/celery/billiard/zipball/main#egg=billiard
pip install https://github.com/celery/py-amqp/zipball/main#egg=amqp
pip install https://github.com/celery/kombu/zipball/main#egg=kombu
pip install https://github.com/celery/vine/zipball/main#egg=vine
}

install_list=(
 https://github.com/celery/celery/zipball/main#egg=celery
 https://github.com/celery/billiard/zipball/main#egg=billiard
 https://github.com/celery/py-amqp/zipball/main#egg=amqp
 https://github.com/celery/kombu/zipball/main#egg=kombu
 https://github.com/celery/vine/zipball/main#egg=vine
);

for lib in ${install_list[@]}; do
  echo  $lib
  pyin_ $lib -q
  pyin_ $lib
done 
