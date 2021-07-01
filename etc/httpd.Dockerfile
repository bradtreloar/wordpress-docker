FROM php:7.4-apache
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal/web

# Install Apache config.
COPY ./etc/apache/vhosts.conf /etc/apache2/sites-available/vhosts.conf
RUN ln -s /etc/apache2/sites-available/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
RUN rm -f /etc/apache2/sites-enabled/000-default.conf

# Enable clean URLs
RUN a2enmod rewrite

# Enable FastCGI proxy module
RUN a2enmod proxy_fcgi

# Restart Apache
RUN service apache2 restart
