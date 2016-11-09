FROM ubuntu:14.04

MAINTAINER victor.yang@hellosanta.com.t

RUN apt-get update
RUN apt-get upgrade -y

# nginx 1.8.1 php5.6

RUN  apt-get install software-properties-common python-software-properties  -y
RUN  apt-get install python-software-properties
RUN  add-apt-repository ppa:nginx/stable
RUN  apt-get update
RUN  apt-get upgrade -y
RUN  apt-get install nginx  -y
RUN  apt-get install software-properties-common
RUN  locale-gen en_US.UTF-8
RUN  export LANG=en_US.UTF-8
RUN  export LANG=C.UTF-8
RUN  add-apt-repository ppa:ondrej/php
RUN  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  4F4EA0AAE5267A6C
RUN  apt-get update
RUN  apt-get upgrade -y
RUN  apt-get install php-fpm -y
RUN  apt-get install php-mysql -y
RUN  apt-get install php-gd -y
RUN  apt-get install php-cli -y
RUN  apt-get install php-curl -y
RUN  apt-get install php-dev -y
RUN  apt-get install php-memcache
RUN  apt-get update
RUN  apt-get upgrade -y

RUN apt-get install nano wget git vim openssh-server supervisor -y
RUN  mkdir -p /usr/share/nginx/www
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /root/sh/


# Setup SSH
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh/
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ADD develop_server.key.pub  /root/.ssh/authorized_keys


# drush
RUN php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush
RUN php drush core-status
RUN chmod +x drush
RUN sudo mv drush /usr/local/bin
RUN drush init -y



# mysql

 RUN apt-get update \
    && apt-get install -y debconf-utils \
    && echo mysql-server mysql-server/root_password password  YOURPASSWORD | debconf-set-selections \
    && echo mysql-server mysql-server/root_password_again password YOURPASSWORD | debconf-set-selections \
    && apt-get install -y mysql-server

EXPOSE 80 22

#啟動檔設定檔
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD  www.conf  /etc/php/5.6/fpm/pool.d/www.conf
ADD  php.ini    /etc/php/5.6/fpm/php.ini
ADD  default   /etc/nginx/sites-available/default
ADD  my.cnf    /etc/mysql/my.cnf
ADD  ./sh/1.sh  /root/sh/
ADD  ./sh/bs.sh /bin/
ADD  nginx.conf /etc/nginx/

CMD ["/usr/bin/supervisord"]
