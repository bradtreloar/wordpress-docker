FROM php:cli
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Install Git
RUN apt-get update && apt-get install -qy git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Drush globally and set it as the entrypoint.
RUN composer global require drush/drush
ENTRYPOINT ["/root/.composer/vendor/bin/drush"]
