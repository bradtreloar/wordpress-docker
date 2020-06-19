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

# Install required packages.
RUN apt-get update -y && apt-get install -qy \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
    git zip mariadb-client zlib1g-dev

# Install PHP extensions
RUN docker-php-ext-configure gd \
    --with-webp \
    --with-jpeg \
    --with-xpm \
    --with-freetype
RUN docker-php-ext-install bcmath gd mysqli opcache pdo pdo_mysql

# Set Drupal Console as the entrypoint.
USER www-data
ENTRYPOINT ["/var/www/drupal/vendor/bin/drupal"]
