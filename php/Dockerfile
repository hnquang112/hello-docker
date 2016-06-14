FROM phusion/baseimage
MAINTAINER Ho Nhat Quang <hnquang112@yahoo.com.vn>

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

CMD ["/sbin/my_init"]

# Nginx-PHP Installation
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y vim curl wget build-essential python-software-properties git
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:nginx/stable
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y --force-yes php7.0 php7.0-dev php7.0-common php7.0-cgi php7.0-fpm php7.0-mysql php7.0-opcache php7.0-intl php7.0-gd php7.0-curl php7.0-mcrypt php7.0-imap php7.0-ldap php7.0-json

# Install php-redis extension for php7
# RUN git clone https://github.com/phpredis/phpredis.git
# RUN cd phpredis && git checkout php7 && phpize && ./configure && make && make install && cd .. && rm -rf phpredis
# RUN echo "extension=redis.so" > /etc/php/mods-available/redis.ini
# RUN ln -sf /etc/php/mods-available/redis.ini /etc/php/7.0/fpm/conf.d/20-redis.ini
# RUN ln -sf /etc/php/mods-available/redis.ini /etc/php/7.0/cli/conf.d/20-redis.ini

# Install php-memcached extension for php7
# RUN apt-get install gcc make autoconf libc-dev pkg-config zlib1g-dev libmemcached-dev
# RUN git clone https://github.com/php-memcached-dev/php-memcached
# RUN cd php-memcached && git checkout php7 && phpize && ./configure && make && make install
# RUN echo "extension=memcached.so" > /etc/php/mods-available/memcached.ini
# RUN ln -sf /etc/php/mods-available/memcached.ini /etc/php/7.0/fpm/conf.d/20-memcached.ini
# RUN ln -sf /etc/php/mods-available/memcached.ini /etc/php/7.0/cli/conf.d/20-memcached.ini

# Install PHP extensions for Laravel
RUN apt-get update && apt-get install -y \
  git \
  libfreetype6-dev \
  # libjpeg62-turbo-dev \
  libjpeg-turbo8-dev \
  libmcrypt-dev \
  libpng12-dev \
  php7.0-pgsql
  # && docker-php-ext-install -j$(nproc) iconv mcrypt mbstring pdo pdo_pgsql \
  # && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  # && docker-php-ext-install -j$(nproc) gd

# Update default config for php
RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini
RUN sed -i 's/memory_limit\ =\ 128M/memory_limit\ =\ 2G/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/\;date\.timezone\ =/date\.timezone\ =\ Asia\/Ho_Chi_Minh/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 200M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/post_max_size\ =\ 8M/post_max_size\ =\ 200M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/max_execution_time\ =\ 30/max_execution_time\ =\ 3600/g' /etc/php/7.0/fpm/php.ini

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini

# create run for create socket of php7fpm
RUN mkdir /run/php

RUN mkdir -p        /var/www
ADD ./default   	/etc/nginx/sites-available/default
RUN mkdir           /etc/service/nginx
ADD ./nginx.sh  	/etc/service/nginx/run
RUN chmod +x        /etc/service/nginx/run
RUN mkdir           /etc/service/phpfpm
ADD ./phpfpm.sh 	/etc/service/phpfpm/run
RUN chmod +x        /etc/service/phpfpm/run

EXPOSE 80 443
# End Nginx-PHP

WORKDIR /var/www/html/

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php -r "if (hash_file('SHA384', 'composer-setup.php') === '070854512ef404f16bac87071a6db9fd9721da1684cd4589b1196c3faf71b9a2682e2311b36a5079825e155ac7ce150d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
  && php composer-setup.php \
  && php -r "unlink('composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*