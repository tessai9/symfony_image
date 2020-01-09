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
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === 'baf1608c33254d00611ac1705c1d9958c817a1a33bce370c0595974b342601bd80b92a3f46067da89e3b06bff421f182') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# install symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN export PATH="$HOME/.symfony/bin:$PATH"
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# git initialization
RUN git config --global user.email "tesao@my-symfony.com"
RUN git config --global user.name "Tesao"

# open port
EXPOSE 8000

# make project folder
RUN symfony new my_proj

# get apache pack
RUN cd my_proj
RUN composer require twig/twig
