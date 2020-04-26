FROM php:7.3
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal

# Use bash instead of sh.
SHELL ["/bin/bash", "-c"]

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Set working directory.
# (Also creates Drupal web directory so Apache restart won't fail.)
WORKDIR /var/www/drupal

ENTRYPOINT ["/var/www/drupal/vendor/bin/drush"]
