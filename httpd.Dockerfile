FROM php:apache
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal/web

# Install Ansible
RUN apt-get update && apt-get install -qy gnupg2
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get update && apt-get install -qy ansible

# Copy and run Ansible playbook
COPY ./ansible/ /ansible
RUN ansible-playbook /ansible/drupal.yml

# Enable clean URLs
RUN a2enmod rewrite

# Enable FastCGI proxy module
RUN a2enmod proxy_fcgi

# Restart Apache
RUN service apache2 restart
