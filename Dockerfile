FROM modpreneur/necktie

MAINTAINER Martin Kolek <kolek@modpreneur.com>

RUN apt-get -y install \
    nano \
    openjdk-7-jre-headless

RUN pecl install xdebug-beta \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini \
    && echo "alias composer=\"php -n -d extension=mbstring.so -d extension=zip.so  /usr/bin/composer\"" >> /etc/bash.bashrc

# Phantomjs for frontend testing
ADD docker/phantomjs /usr/local/bin/phantomjs

# Selenium for js test
ADD docker/selenium-server-standalone-2.52.0.jar /opt/selenium-server-standalone.jar

# terminal env for nano
ENV TERM xterm