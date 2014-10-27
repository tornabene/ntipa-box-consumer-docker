ntipa-box-consumer-docker
=========================

sudo docker run -d   --dns 10.10.130.5 -P --name ntipaBoxConsumer -t -i tornabene/ntipa-box-consumer-docker


### To build:
	Spostarsi nella directory e lanciare il comando
    sudo docker build tornabene/ntipa-box-consumer-docker .
    

### To run:

    sudo docker pull tornabene/ntipa-box-consumer-docker
    sudo docker run -d --name consumer1.ntipa.it -P  tornabene/ntipa-box-consumer-docker
    sudo docker run -d --dns 10.10.130.5  -P --name ntipaBoxConsumer -t -i tornabene/ntipa-box-consumer-docker
    
    