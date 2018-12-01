FROM ubuntu:xenial
RUN apt-get update &&\
    apt-get install --reinstall -y locales  &&\
    sed -i 's/# pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen &&\
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&\
    locale-gen pl_PL.UTF-8 &&\
    locale-gen en_US.UTF-8 &&\
    apt-get install -y build-essential cmake bison flex python-dev swig git subversion &&\
    apt-get install -y libicu-dev libboost1.58-all-dev libloki-dev libxml++2.6-dev libedit-dev libreadline-dev &&\
    apt-get install -y wget software-properties-common python-software-properties &&\
    apt-get install -y sudo libncurses-dev python3-pip unzip &&\
    apt-get install -y python-setuptools python-stdeb python-pip python-all-dev python-pyparsing devscripts libcppunit-dev acl &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN pip3 install --upgrade pip
RUN pip3 install keras==2.1.2 regex progress setproctitle h5py tensorflow flask
RUN echo 'krnnt\nkrnnt\n' | adduser krnnt --home /home/krnnt --ingroup sudo

USER krnnt
RUN cd &&\
    git clone -b morfeusz2018 http://github.com/djstrong/corpus2.git &&\
    cd /home/krnnt/corpus2 &&\
    mkdir bin &&\
    cd bin &&\
    export CXXFLAGS="--std=c++0x" &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    rm -rf /home/krnnt/corpus2
RUN cd &&\ 
    git clone http://github.com/apohllo/toki.git &&\
    cd /home/krnnt/toki &&\
    mkdir bin &&\
    cd bin &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    rm -rf /home/krnnt/toki

RUN cd &&\ 
    git clone https://github.com/kwrobel-nlp/krnnt &&\
    cd krnnt &&\
    mkdir data &&\
    cd data &&\
    wget https://github.com/kwrobel-nlp/krnnt/releases/download/poleval/reanalyze_150epochs_train1.0.zip &&\
    unzip reanalyze_150epochs_train1.0.zip &&\
    mv weights_reana150_1.0.hdf5 weights.hdf5 &&\
    mv lemmatisation_reana150_1.0.pkl lemmatisation.pkl &&\
    rm reanalyze_150epochs_train1.0.zip
ENV PYTHONIOENCODING utf-8

RUN cd &&\
    mkdir morfeusz &&\
    cd morfeusz &&\
    wget http://sgjp.pl/morfeusz/download/20180923/morfeusz-src-20180923.tar.gz &&\
    tar xvzf morfeusz-src-*.tar.gz &&\
    wget http://sgjp.pl/morfeusz/download/20180923/sgjp-20180923.tab.gz &&\
    gunzip sgjp-*.tab.gz &&\
    mkdir build &&\
    cd build &&\
    # delete 2 lines from CMake in wrappers
    sed -i "s/.*\(java\|perl\).*//g" ../morfeusz/wrappers/CMakeLists.txt &&\ 
    # or delete CMake..
    cmake -D INPUT_DICTIONARIES=/home/krnnt/morfeusz/sgjp-20180923.tab -D DEFAULT_DICT_NAME=sgjp -D EMBEDDED_DEFAULT_DICT=1 -D INPUT_TAGSET=/home/krnnt/morfeusz/input/morfeusz-sgjp.tagset -D PY=2.7 .. &&\ 
    make -j4 &&\
    #cd /home/krnnt/morfeusz/build &&\
    echo 'krnnt' | sudo -S make install &&\
    #echo 'krnnt' | sudo -S PYTHONPATH=/usr/local/lib/python/ make install-python &&\
    #sudo make install-python2 # tu się wywali
    cd morfeusz/wrappers/python2 &&\
    echo 'krnnt' | sudo -S python setup.py install &&\
    echo 'krnnt' | sudo -S ldconfig
 
RUN cd &&\ 
    git clone -b morfeusz2018 http://github.com/djstrong/maca.git &&\
    cd /home/krnnt/maca/third_party/SFST-1.2/SFST/src/ &&\
    make &&\
    echo 'krnnt' | sudo -S make install &&\
    cd /home/krnnt/maca &&\
    #sed -i  "s/#include <morfeusz\.h>/#include <morfeusz2.h>/g" /home/krnnt/maca/libmaca/morph/guesser2.cpp
    mkdir bin &&\
    cd bin &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    echo 'krnnt' | sudo -S ldconfig &&\
    rm -rf /home/krnnt/maca

#RUN python3 krnnt_run.py data/weights.hdf5 data/lemmatisation.pkl data/dictionary.pkl --maca_config morfeusz2-nkjp --toki_config_path /home/krnnt/ -o conll
