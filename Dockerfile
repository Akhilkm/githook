# Base image centos 7
FROM centos:7

# Maintained by
MAINTAINER Amal K Raj

# Container working directory
WORKDIR /opt/

# Environment varaibles
ENV APACHE_VERION 2.4.43
ENV APACHE_HOME /opt/apache2

# Installing dependancies
RUN yum update -y \
    && yum install -y wget vim net-tools cmake make gcc openssl-devel expat-devel deltarpm 

# Installing apacahe2
RUN wget https://mirrors.estointernet.in/apache//httpd/httpd-$APACHE_VERION.tar.gz \
    && tar -zxvf httpd-${APACHE_VERION}.tar.gz \
    && cd httpd-${APACHE_VERION} \
    && cd srclib \
    && wget https://mirrors.estointernet.in/apache//apr/apr-1.7.0.tar.gz \
    && wget https://mirrors.estointernet.in/apache//apr/apr-util-1.6.1.tar.gz \
    && tar -zxvf apr-1.7.0.tar.gz \
    && tar -zxvf apr-util-1.6.1.tar.gz \
    && rm -rf  *.tar.gz \
    && mv apr-1.7.0 apr \
    && mv apr-util-1.6.1 apr-util \
    && cd .. \
    && ./configure --prefix=/opt/apache2 --with-included-apr \
    && make \
    && make install \
    && cd /opt/ \
    && rm -rf /opt/httpd-2.4.43*

# Changing to apache home folder
WORKDIR /opt/apache2

# Install Php

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum -y install yum-utils \
    && yum-config-manager --enable remi-php74 \
    && yum update -y \
    && yum install -y php php-pdo php-mysqlnd php-opcache php-xml php-mcrypt php-gd php-devel php-mysql php-intl php-mbstring php-json php-iconv \
    && php --modules 

# Entrypoint
CMD ["apachectl -D", "FOREGROUND"]
