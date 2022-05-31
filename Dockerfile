FROM	debian:buster

RUN		apt-get	update && apt-get	upgrade -y && apt-get	-y	install	\
wget \
nginx \
mariadb-server \
php7.3 php-mysql php-fpm php-pdo php-gd	php-cli php-mbstring
COPY ./srcs/swap_autoindex.sh ./
WORKDIR	/var/www/html/

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz

RUN	tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz

RUN mv phpMyAdmin-5.0.1-english phpmyadmin

RUN	wget https://wordpress.org/latest.tar.gz
RUN	tar	-xvzf	latest.tar.gz	&&	rm	-rf	latest.tar.gz

COPY ./srcs/default /etc/nginx/sites-available/
COPY ./srcs/wp-config.php /var/www/html/wordpress
COPY ./srcs/config.inc.php phpmyadmin

RUN openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Russia/L=Moscow/0=school21/OU=21Moscow/CN=lsinistr" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*
COPY ./srcs/init.sh ./
CMD bash init.sh
