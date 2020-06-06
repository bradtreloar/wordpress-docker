FROM php:cli
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal

# Create user www-data with same UID:GID as host user.
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN userdel -f www-data &&\ 
    if getent group www-data ; then groupdel www-data; fi &&\
    groupadd -g ${GROUP_ID} www-data &&\
    useradd -l -u ${USER_ID} -g www-data www-data &&\
    install -d -m 0755 -o www-data -g www-data /home/www-data &&\
    chown --changes --no-dereference --recursive --from=33:33 ${USER_ID}:${GROUP_ID} /home/www-data

# Install GD dependencies
RUN apt-get update -y && apt-get install -y \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev

# Install PHP extensions
RUN docker-php-ext-configure gd \
    --with-webp \
    --with-jpeg \
    --with-xpm \
    --with-freetype
RUN docker-php-ext-install mysqli pdo pdo_mysql opcache gd

# Install required packages.
RUN apt-get update && apt-get install -qy git zip mariadb-client

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush globally and set it as the entrypoint.
USER www-data
RUN composer global require drush/drush
ENTRYPOINT ["/home/www-data/.composer/vendor/bin/drush"]
