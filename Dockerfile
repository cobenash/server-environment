FROM ubuntu:14.04

MAINTAINER wazlo200444@gmail.com

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
RUN  add-apt-repository ppa:ondrej/php5-5.6
RUN  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys  4F4EA0AAE5267A6C
RUN  apt-get update
RUN  apt-get upgrade -y
RUN  apt-get install php5-fpm -y
RUN  apt-get install php5-mysql -y
RUN  apt-get install php5-gd -y
RUN  apt-get install php5-cli -y
RUN  apt-get install php5-curl -y

RUN apt-get install nano wget git vim openssh-server supervisor -y
RUN  mkdir -p /usr/share/nginx/www
RUN mkdir -p /var/log/supervisor


# Setup SSH
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN mkdir /var/run/sshd && chmod 0755 /var/run/sshd
RUN mkdir -p /root/.ssh/
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ADD develop_server.key.pub  /root/.ssh/authorized_keys



# drush
RUN wget http://files.drush.org/drush.phar
RUN php drush.phar core-status
RUN chmod +x drush.phar
RUN sudo mv drush.phar /usr/local/bin/drush
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
ADD  www.conf  /etc/php5/fpm/pool.d/www.conf
ADD  php.ini    /etc/php5/fpm/php.ini
ADD  default   /etc/nginx/sites-available/default
ADD  my.cnf    /etc/mysql/my.cnf
ADD  1.sh      /

CMD ["/usr/bin/supervisord"]
