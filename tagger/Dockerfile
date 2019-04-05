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
# don't install morfeusz 2 for now - it doesn't work with Maca
#   wget -O - http://sgjp.pl/apt/sgjp.gpg.key | apt-key add - &&\
#   add-apt-repository 'deb http://sgjp.pl/apt/ubuntu trusty main' &&\
#   apt-get update &&\
#   apt-get install -y morfeusz2 morfeusz2-dictionary-sgjp libmorfeusz2 libmorfeusz2-dev python-morfeusz2 &&\
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*
RUN pip3 install keras==2.1.2 regex progress setproctitle h5py tensorflow flask jsonlines
RUN echo 'krnnt\nkrnnt\n' | adduser krnnt --home /home/krnnt --ingroup sudo
USER krnnt
RUN cd &&\
    git clone http://github.com/apohllo/corpus2.git &&\
    cd /home/krnnt/corpus2 &&\
    mkdir bin &&\
    cd bin &&\
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
    mkdir morfeusz &&\
    cd morfeusz &&\
    wget https://launchpad.net/~bartosz-zaborowski/+archive/ubuntu/nlp/+files/morfeusz-sgjp_0.81-1_amd64.deb &&\
    echo 'krnnt' | sudo dpkg -i morfeusz-sgjp_0.81-1_amd64.deb &&\
    rm -rf /home/krnnt/morfeusz
RUN cd &&\ 
    git clone http://github.com/apohllo/maca.git &&\
    cd /home/krnnt/maca/third_party/SFST-1.2/SFST/src/ &&\
    make &&\
    echo 'krnnt' | sudo -S make install &&\
    cd /home/krnnt/maca &&\
    mkdir bin &&\
    cd bin &&\
    cmake .. &&\
    make -j4 &&\
    echo 'krnnt' | sudo -S make install &&\
    echo 'krnnt' | sudo -S ldconfig &&\
    rm -rf /home/krnnt/maca
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
