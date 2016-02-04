# Base image, other options here https://hub.docker.com/_/php/
FROM php:5.6-apache

MAINTAINER Raymond Ho <rayho65@gmail.com>

COPY webapp/ /var/www/html/
COPY my-webapp.conf /etc/apache2/sites-available/

# Get utilities and extensions
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install \
        git \
        curl \
        php5-mcrypt \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc \
        zlib1g-dev \
        libicu-dev \
        g++ \
        libmcrypt-dev \
        libssl-dev \
        mlocate

# Extensions
RUN docker-php-ext-configure intl
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip
RUN docker-php-ext-install mcrypt
RUN pecl install mongo

# Enable mongo
COPY mongo.ini /usr/local/etc/php/conf.d

# So we can use 'locate' in our container
RUN updatedb

# Enable apache mods
RUN a2enmod rewrite
RUN a2ensite my-webapp.conf
RUN service apache2 restart
