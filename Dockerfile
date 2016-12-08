FROM modpreneur/necktie

MAINTAINER Martin Kolek <kolek@modpreneur.com>

RUN apt-get update && apt-get -y install \
    nano \
    openjdk-7-jdk \
    ant \
    parallel \
    && echo "max_execution_time=60" >> /usr/local/etc/php/php.ini \
    && docker-php-ext-install pcntl \
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g less \
    && npm install -g webpack  --save-dev \
    && npm install -g uglifycss \
    && composer global require phpunit/phpunit \
    && composer global require codeception/codeception \
    && echo "alias codecept=\"php -n -d extension=pdo_pgsql.so -d extension=pdo_mysql.so -d extension=apcu.so -d extension=apc.so /var/app/vendor/codeception/codeception/codecept\"" >> /etc/bash.bashrc \
    && npm -g install eslint eslint-plugin-react \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_output_dir=/var/app/var/xdebug/" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/php.ini \
    && echo "alias composer=\"php -n -d memory_limit=2048M -d extension=bcmath.so -d extension=zip.so /usr/bin/composer\"" >> /etc/bash.bashrc

ENV BLACKFIRE_CLIENT_ID 86868e87-ef71-4d80-b099-00eec1203f70 \
    && BLACKFIRE_CLIENT_TOKEN 078a0dfe33c4736f9636c2f304969e55f47034cd83d47b41f8acb68891021372 \
    && BLACKFIRE_SERVER_ID 527e8db7-a650-4dd2-b65c-27a76e30b989 \
    && BLACKFIRE_SERVER_TOKEN b7009cd33c9b4165c0421bd221557c4c05831fedc7c01474b13253c2f0a488f3

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini

# terminal env for nano
ENV TERM xterm

RUN echo "modpreneur/necktie-dev:1.0.16" >> /home/versions