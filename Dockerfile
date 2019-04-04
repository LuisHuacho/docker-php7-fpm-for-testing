FROM php:5.6-apache

MAINTAINER DRINUX SAC "proyectos@drinux.com"

RUN apt-get update

RUN a2enmod rewrite

# Tools for network testing with others containers

RUN apt-get install -y vim nmap lynx

# Libraries that are required by php extensions

RUN apt-get install -y zlib1g-dev vim libicu-dev libpng-dev libldb-dev libldap2-dev libmcrypt-dev libxml2-dev

RUN apt-get -y install jpegoptim optipng gifsicle libjpeg-dev libfreetype6-dev libgd-dev

RUN apt-get -y install libwebp-dev libjpeg62-turbo-dev libxpm-dev

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so

RUN pecl install apcu-4.0.11 && docker-php-ext-enable apcu

# PHP Extensions

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf

RUN docker-php-ext-install gd

RUN docker-php-ext-install pdo pdo_mysql zip intl ldap mcrypt soap

RUN docker-php-ext-install mysqli

RUN docker-php-ext-enable opcache

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql

RUN docker-php-ext-install pdo_pgsql pgsql

WORKDIR /usr/local/etc/php/conf.d

COPY app.ini app.ini

WORKDIR /etc/apache2/sites-available

RUN mv 000-default.conf 000-default.conf.backup

COPY appweb.conf 000-default.conf

WORKDIR /var/www/

RUN mkdir log

# If Web App requires directory for files upload or processing outside web directory. 
# Moodle for example with moodledata directory.

RUN mkdir data

RUN chown -R www-data:www-data html data

RUN chmod -R 775 html data

WORKDIR /var/www/html