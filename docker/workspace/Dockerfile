FROM phusion/baseimage:latest

MAINTAINER Paul Allen <paul@paulallen.org>

RUN DEBIAN_FRONTEND=noninteractive
RUN locale-gen en_US.UTF-8

ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=UTF-8
ENV LANG=en_US.UTF-8
ENV TERM xterm

# Add a non-root user

ARG PUID=1000
ARG PGID=1000
ARG USERNAME=allenp

ENV PUID ${PUID}
ENV PGID ${PGID}
ENV USERNAME ${USERNAME}

RUN groupadd -g ${PGID} ${USERNAME} && \
    useradd -u ${PUID} -g www-data -m ${USERNAME} && \
    adduser ${USERNAME} www-data && \
    adduser ${USERNAME} sudo

USER root
# Install "software-properties-common" (for the "add-apt-repository")
RUN apt-get update && apt-get install -y \
  software-properties-common

RUN add-apt-repository -y ppa:ondrej/php

RUN apt-get update && \
    apt-get install -y --allow-downgrades --allow-remove-essential \
        --allow-change-held-packages \
        php5.6-cli \
        php5.6-common \
        php5.6-curl \
        php5.6-intl \
        php5.6-json \
        php5.6-xml \
        php5.6-mbstring \
        php5.6-mcrypt \
        php5.6-mysql \
        php5.6-pgsql \
        php5.6-sqlite \
        php5.6-sqlite3 \
        php5.6-zip \
        php5.6-bcmath \
        php5.6-memcached \
        php5.6-gd \
        php5.6-dev \
	php5.6-soap \
        pkg-config \
        libcurl4-openssl-dev \
        libedit-dev \
        libssl-dev \
        libxml2-dev \
        xz-utils \
        libsqlite3-dev \
        sqlite3 \
        git \
        curl \
        vim \
        nano \
        postgresql-client \
        mysql-client \
        mongodb-clients \
	&& apt-get clean



# Load the xdebug extension only with phpunit commands
RUN apt-get install -y --force-yes php5.6-xdebug && \
    sed -i 's/^;//g' /etc/php/5.6/cli/conf.d/20-xdebug.ini && \
    echo "alias phpunit='php -dzend_extension=xdebug.so /var/www/edufocal/api/vendor/bin/phpunit'" >> /home/${USERNAME}/.bashrc

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/edufocal/api/vendor/bin" >> /home/${USERNAME}/.bashrc && \
    mv composer.phar /usr/local/bin/composer

# Source the bash
RUN . /home/${USERNAME}/.bashrc


# Load xdebug Zend extension with phpunit command
RUN echo "alias phpunit='php -dzend_extension=xdebug.so /var/www/edufocal/api/vendor/bin/phpunit'" >> /home/${USERNAME}/.bashrc

# Install mongodb extension
RUN pecl install mongodb && pecl install mongo
RUN echo "extension=mongodb.so" >> /etc/php/5.6/cli/php.ini
RUN echo "extension=mongo.so" >> /etc/php/5.6/cli/php.ini

USER ${USERNAME}
# Install nvm (Node Version Manager)
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.1/install.sh | bash

ENV NVM_DIR=/home/${USERNAME}/.nvm

# Install stable node
RUN . /home/${USERNAME}/.nvm/nvm.sh && \
  nvm install stable && \
  nvm use stable && \
  nvm alias stable && \
  npm install -g gulp bower grunt-cli elasticsearch-tools



USER root
RUN apt-get install -y -qq ruby-dev
RUN apt-get install make
RUN gem install --no-rdoc --no-ri compass

# Setup vim plugins and configs
RUN git clone https://github.com/amix/vimrc.git /home/${USERNAME}/.vim_runtime

# Source the bash
RUN . /home/${USERNAME}/.bashrc

RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/
USER ${USERNAME}

RUN bash /home/${USERNAME}/.vim_runtime/install_awesome_vimrc.sh
RUN echo "source ~/.nvm/nvm.sh" >> /home/${USERNAME}/.bashrc
RUN echo "export LARAVEL_ENV=local" >> /home/${USERNAME}/.bashrc && \
    echo "export ENV=local" >> /home/${USERNAME}/.bashrc

ADD my_configs.vim /home/${USERNAME}/.vim_runtime/
ADD .ssh/id_rsa /home/${USERNAME}/.ssh/
ADD .ssh/id_rsa.pub /home/${USERNAME}/.ssh/

USER root
ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh/
RUN chmod 700 /home/${USERNAME}/.ssh/ && \
    chmod 600 /home/${USERNAME}/.ssh/id_rsa
# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/edufocal

RUN chown -R ${USERNAME}:www-data /var/www/edufocal
