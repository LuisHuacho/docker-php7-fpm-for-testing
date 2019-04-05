FROM php:5.6-apache

MAINTAINER DRINUX SAC "proyectos@drinux.com"

RUN a2enmod rewrite

RUN apt-get update && apt-get install -y \
#    vim nmap lynx apt-utils \
    zlib1g-dev libicu-dev libpng-dev \
    libldb-dev libldap2-dev \
    libmcrypt-dev libxml2-dev libpq-dev \
    jpegoptim optipng gifsicle libjpeg-dev \
    libfreetype6-dev libgd-dev \
    libwebp-dev libjpeg62-turbo-dev libxpm-dev

RUN ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so && \
    ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so && \
    pecl install apcu-4.0.11

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir \
    --enable-gd-native-ttf

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
    docker-php-ext-install gd pdo pdo_mysql zip intl ldap mcrypt soap mysqli pdo_pgsql pgsql && \
    docker-php-ext-enable opcache apcu

WORKDIR /usr/local/etc/php/conf.d

COPY app.ini app.ini

WORKDIR /etc/apache2/sites-available

RUN mv 000-default.conf 000-default.conf.backup

COPY appweb.conf 000-default.conf

WORKDIR /var/www/

RUN mkdir log data && \
    chown -R www-data:www-data html data && \
    chmod -R 775 html data

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html