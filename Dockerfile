FROM ubuntu:18.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install apt-utils -y
RUN apt-get install git -y
RUN git clone https://github.com/ShuangLiu1992/apprtc.git

RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:longsleep/golang-backports -y
RUN apt-get update
RUN apt-get install golang-go -y

RUN mkdir -p /cert && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US" \
    -keyout /cert/key.pem -out /cert/cert.pem

RUN export GOPATH=$HOME/goWorkspace && \
    mkdir -p $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collider $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collidermain $GOPATH/src && \
    ln -s `pwd`/apprtc/src/collider/collidertest $GOPATH/src && \
    go get collidermain && \
    go install collidermain

RUN apt-get install npm python-pip -y

RUN npm install -g npm@latest
RUN apt-get install openjdk-8-jdk -y
RUN cd apprtc; npm install; pip install -r requirements.txt
RUN npm install -g grunt-cli
RUN java -version
RUN cd apprtc; grunt build
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN apt-get install apt-transport-https ca-certificates -y
RUN apt-get install curl -y
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update && apt-get install google-cloud-sdk -y
RUN apt-get install google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras -y

RUN apt-get install google-cloud-sdk-app-engine-python google-cloud-sdk-app-engine-python-extras google-cloud-sdk-datastore-emulator -y
RUN apt-get install net-tools -y
RUN dev_appserver.py apprtc/out/app_engine/ --host=192.168.1.203
