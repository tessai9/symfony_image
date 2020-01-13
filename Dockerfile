# based on centos 8
FROM centos:8

# maintainer
MAINTAINER Tesao

# install packages
RUN yum -y upgrade
RUN yum -y install wget zip unzip nginx emacs
RUN yum -y install php php-common php-json php-xml php-pdo git

# add user
RUN useradd _www

# move to home directory
WORKDIR /srv

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# install symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN export PATH="$HOME/.symfony/bin:$PATH"
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# open port
EXPOSE 8000

# git initialization for example
RUN git config --global user.email "tesao@tesao.work"
RUN git config --global user.name "Tesao"

# make project folder
RUN symfony new proj --version=4.4

# get apache pack
RUN cd proj
RUN composer require twig/twig
