FROM ubuntu:18.04
RUN export DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install git -y
RUN git clone https://github.com/ShuangLiu1992/apprtc.git

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:longsleep/golang-backports -y
RUN apt-get update
RUN apt-get install golang-go -y

RUN export GOPATH=$HOME/goWorkspace && \
    mkdir -p $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collider $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collidermain $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collidertest $GOPATH/src && \
    go get collidermain && \
    go install collidermain

RUN cd apprtc