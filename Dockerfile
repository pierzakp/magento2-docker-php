FROM mageinferno/magento2-php:7.0-fpm-1

MAINTAINER Piotr Pierzak piotrek.pierzak@gmail.com

RUN apt-get update && apt-get install -y \
    wget \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN wget -O - https://packagecloud.io/gpg.key | apt-key add - \
    && echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

RUN apt-get update && apt-get install -y \
    blackfire-agent \
    blackfire-php

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -f /usr/local/bin/setup-config \
    && rm -f /usr/local/bin/start

COPY setup-config.sh /usr/local/bin/setup-config
COPY start.sh /usr/local/bin/start
