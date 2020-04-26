FROM php:7.3-apache
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal

# Use bash instead of sh.
SHELL ["/bin/bash", "-c"]

# Install GD dependencies
RUN apt-get update -y && apt-get install -y \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo pdo_mysql opcache gd

# Install Ansible
RUN apt-get update && apt-get install -qy gnupg2
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install -qy ansible

# Copy Ansible configuration and playbook, then run playbook
COPY ./ansible/ /ansible
COPY ./config.yml /ansible/config.yml
RUN ansible-playbook /ansible/drupal.yml

# Enable clean URLs
RUN a2enmod rewrite

# Set working directory.
# (Also creates Drupal web directory so Apache restart won't fail.)
WORKDIR /var/www/drupal/web

# Add Drupal vendor binaries directory to PATH
ENV PATH="/var/www/drupal/vendor/bin:${PATH}"

# Restart Apache
RUN service apache2 restart
