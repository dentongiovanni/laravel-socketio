FROM php:7.3.1-fpm

RUN apt-get update && apt-get install -y libmcrypt-dev \
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pcntl \
    && openssl 

# Memory Limit
RUN echo "memory_limit = -1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "upload_max_filesize = 999M" > $PHP_INI_DIR/conf.d/max-file-size.ini
RUN echo "post_max_size = 999M" > $PHP_INI_DIR/conf.d/post-max-size.ini


RUN echo "always_populate_raw_post_data=-1" > $PHP_INI_DIR/conf.d/always_populate_raw_post_data.ini    

RUN apt-get -y install nano

RUN cd ~ \
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "if (hash_file('SHA384', 'composer-setup.php') === '795f976fe0ebd8b75f26a6dd68f78fd3453ce79f32ecb33e7fd087d39bfeb978342fb73ac986cd4f54edd0dc902601dc') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
 && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
 && php -r "unlink('composer-setup.php');" 

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash
RUN apt-get install --yes nodejs
RUN node -v
RUN npm -v
RUN npm i -g nodemon
RUN nodemon -v
RUN npm i npm@latest -g
RUN npm install -g laravel-echo-server
