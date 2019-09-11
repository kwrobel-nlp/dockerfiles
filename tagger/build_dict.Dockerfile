FROM ubuntu:bionic
RUN apt-get update &&\
    apt-get install --reinstall -y locales  &&\
    sed -i 's/# pl_PL.UTF-8 UTF-8/pl_PL.UTF-8 UTF-8/' /etc/locale.gen &&\
    sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen &&\
    locale-gen pl_PL.UTF-8 &&\
    locale-gen en_US.UTF-8 &&\
    apt-get install -y build-essential cmake bison flex python-dev swig git subversion &&\
    apt-get install -y libicu-dev libboost-all-dev libloki-dev libxml++2.6-dev libedit-dev libreadline-dev &&\
    apt-get install -y wget software-properties-common &&\
    apt-get install -y sudo libncurses-dev python3-pip unzip &&\
    apt-get install -y python-setuptools python-stdeb python-pip python-all-dev python-pyparsing devscripts libcppunit-dev acl &&\
    apt-get install -y curl hdf5-tools &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN pip3 install --upgrade pip setuptools
RUN pip3 install Cython numpy


RUN export LC_ALL=en_US.UTF-8
RUN export LANG=en_US.UTF-8

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
    echo 'krnnt' | sudo -S make install

RUN cd &&\ 
    git clone -b ubuntu18 https://github.com/djstrong/toki &&\
    cd /home/krnnt/toki &&\
    mkdir bin &&\
    cd bin &&\
    export CXXFLAGS="--std=c++0x" &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install

RUN cd &&\ 
    git clone -b refactor2 https://github.com/kwrobel-nlp/krnnt &&\
    cd krnnt &&\
    echo 'krnnt' | sudo -S pip3 install -e .[tfcpu] &&\
    mkdir model_data &&\
    cd model_data &&\
    wget https://github.com/kwrobel-nlp/krnnt/releases/download/poleval/reanalyze_150epochs_train1.0.zip &&\
    unzip reanalyze_150epochs_train1.0.zip &&\
    mv weights_reana150_1.0.hdf5 weights.hdf5 &&\
    mv lemmatisation_reana150_1.0.pkl lemmatisation.pkl &&\
    rm reanalyze_150epochs_train1.0.zip
ENV PYTHONIOENCODING utf-8

RUN cd &&\
    mkdir morfeusz &&\
    cd morfeusz &&\
    wget https://github.com/kwrobel-nlp/krnnt/releases/download/poleval/morfeusz-src-20180923.tar.gz &&\
    tar xvzf morfeusz-src-*.tar.gz &&\
    wget https://github.com/kwrobel-nlp/krnnt/releases/download/poleval/sgjp-20180923.tab.gz &&\
    gunzip sgjp-*.tab.gz &&\
    mkdir build &&\
    cd build &&\
    # delete 2 lines from CMake in wrappers
    sed -i "s/.*\(java\|perl\).*//g" ../morfeusz/wrappers/CMakeLists.txt &&\ 
    cmake -D INPUT_DICTIONARIES=/home/krnnt/morfeusz/sgjp-20180923.tab -D DEFAULT_DICT_NAME=sgjp -D EMBEDDED_DEFAULT_DICT=1 -D INPUT_TAGSET=/home/krnnt/morfeusz/input/morfeusz-sgjp.tagset -D PY=3.4 .. &&\ 
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    cd morfeusz/wrappers/python3 &&\
    echo 'krnnt' | sudo -S python3 setup.py install &&\
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
    export CXXFLAGS="--std=c++0x" &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    echo 'krnnt' | sudo -S ldconfig

RUN cd &&\
    git clone https://github.com/Zhylkaaa/maca_analyse &&\
    cd maca_analyse &&\
    chmod u+x build_maca_analyse_wrapper.sh &&\
    echo 'krnnt' | sudo -S ./build_maca_analyse_wrapper.sh

#docker run -p 9200:9200 -it <image_name> bash -c "cd home/krnnt/krnnt/ && ./start_gunicorn_server.sh"
