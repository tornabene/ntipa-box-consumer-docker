# NTIPA-CONSUMER-VERSION 0.0.1
FROM      ubuntu:12.04
MAINTAINER Tindaro Tornabene <tindaro.tornabene@gmail.com>
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y -q  install  python-software-properties software-properties-common
RUN apt-get -y install openssh-server && mkdir /var/run/sshd
RUN apt-get -y install vim git zip bzip2 fontconfig curl
RUN apt-get -y install supervisor
RUN apt-get -y install ghostscript
RUN apt-get -y install libgs-dev
RUN apt-get -y install graphicsmagick
RUN apt-get -y install graphicsmagick-imagemagick-compat
RUN apt-get -y install build-essential
RUN apt-get -y install checkinstall
RUN apt-get -y install autoconf automake libtool
RUN apt-get -y install libjpeg62-dev
RUN apt-get -y install libtiff4
RUN apt-get -y install tesseract-ocr-ita
RUN apt-get -y install libhocr0
RUN apt-get -y install ruby
RUN apt-get -y install libreoffice
RUN apt-get install -yqq inetutils-ping net-tools

# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java7-installer && apt-get clean

# Set oracle java as the default java
RUN update-java-alternatives -s java-7-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> ~/.bashrc

WORKDIR /opt

RUN git clone https://github.com/dagwieers/unoconv 
WORKDIR unoconv
RUN make install

RUN git clone https://github.com/gkovacs/pdfocr.git
WORKDIR pdfocr
RUN ln -s /tmp/pdfocr/pdfocr.rb /usr/bin/pdfocr

 
WORKDIR /etc/supervisor/conf.d
ADD ntipaboxconsumer.conf  /etc/supervisor/conf.d/ntipaboxconsumer.conf
RUN mkdir -p   /var/run/sshd /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /opt
RUN mkdir devpublic
WORKDIR /opt/devpublic
RUN wget http://tweb2.ipublic.it/nexus/service/local/repositories/ipublic/content/snapshots/com/ipublic/ntipa/ntipa-box-consumer/0.0.1-SNAPSHOT/ntipa-box-consumer-0.0.1-20141023.090124-4.war -O /opt/devpublic/ntipa-box-consumer-0.0.1-SNAPSHOT.war

# configure the "ntipa" and "root" users
RUN echo 'root:ntipa' |chpasswd
RUN groupadd ntipa && useradd ntipa -s /bin/bash -m -g ntipa -G ntipa && adduser ntipa sudo
RUN echo 'ntipa:ntipa' |chpasswd	
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


# expose the SSHD port, and run SSHD
EXPOSE 22
EXPOSE 8080
EXPOSE 2002
CMD ["/usr/bin/supervisord"]
