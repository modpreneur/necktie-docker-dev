FROM modpreneur/necktie

MAINTAINER Martin Kolek <kolek@modpreneur.com>

RUN apt-get -y install \
    nano \
    openjdk-7-jre-headless \
    phpunit \
    && docker-php-ext-install pcntl \
    && composer global require codeception/codeception \
    && echo "alias codecept=\"php /var/app/vendor/codeception/codeception/codecept\"" >> /etc/bash.bashrc \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini \
    && echo "alias composer=\"php -n -d extension=mbstring.so -d extension=zip.so -d extension=bcmath.so /usr/bin/composer\"" >> /etc/bash.bashrc


# Phantomjs for frontend testing
COPY docker/phantomjs /usr/local/bin/phantomjs

# Selenium for js test
COPY docker/selenium-server-standalone-2.53.0.jar /opt/selenium-server-standalone.jar

# terminal env for nano
ENV TERM xterm