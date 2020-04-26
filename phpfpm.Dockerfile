FROM php:fpm
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal/web

# Install GD dependencies
RUN apt-get update -y && apt-get install -y \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql opcache gd
