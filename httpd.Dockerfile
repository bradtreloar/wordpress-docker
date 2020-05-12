FROM php:apache
LABEL maintainer="Brad Treloar"
WORKDIR /var/www/drupal/web

# # Create user www-data with same UID:GID as host user.
# ARG USER_ID=1000
# ARG GROUP_ID=1000
# RUN userdel -f www-data &&\ 
#     if getent group www-data ; then groupdel www-data; fi &&\
#     groupadd -g ${GROUP_ID} www-data &&\
#     useradd -l -u ${USER_ID} -g www-data www-data &&\
#     install -d -m 0755 -o www-data -g www-data /home/www-data

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

# Enable FastCGI proxy module
RUN a2enmod proxy_fcgi

# Restart Apache
RUN service apache2 restart
