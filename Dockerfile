FROM php:fpm

MAINTAINER DRINUX SAC "proyectos@drinux.com"

RUN apt-get update && apt-get install -y \
#    vim nmap lynx apt-utils \
    zlib1g-dev libicu-dev libpng-dev \
    libldb-dev libldap2-dev \
    libmcrypt-dev libxml2-dev libpq-dev \
    jpegoptim optipng gifsicle libjpeg-dev \
    libfreetype6-dev libgd-dev \
    libz-dev libmemcached-dev libmemcached11 libmemcachedutil2 build-essential \
    libwebp-dev libjpeg62-turbo-dev libxpm-dev \
    git

RUN docker-php-ext-configure gd \
    --with-gd \
    --with-webp-dir \
    --with-jpeg-dir \
    --with-png-dir \
    --with-zlib-dir \
    --with-xpm-dir \
    --with-freetype-dir && \
    pecl install mcrypt-1.0.2 && \
    docker-php-ext-enable mcrypt && \
    docker-php-ext-enable opcache && \
    docker-php-ext-install gd pdo pdo_mysql intl ldap mbstring soap soap xml mysqli pdo_pgsql ldap pgsql

WORKDIR /usr/local/etc/php/conf.d
COPY app.ini app.ini
WORKDIR /var/www/

RUN mkdir log && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html