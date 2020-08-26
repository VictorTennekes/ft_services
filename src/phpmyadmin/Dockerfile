FROM alpine:3.12

RUN apk update && \
    apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php7-zip && \
    mkdir -p /www/tmp && \
	apk add wget curl nginx gettext
RUN	apk add supervisor

RUN mkdir -p /run/nginx

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz && \
	tar -xzvf phpMyAdmin-5.0.1-english.tar.gz --strip-components=1 -C /www && \
	chmod 777 /www/tmp

RUN adduser -D -g 'www' www

COPY ./srcs/config.inc.php /www
COPY ./srcs/nginx.conf /etc/nginx/nginx.conf
COPY ./srcs/nginx.conf /etc/nginx.conf
COPY ./srcs/supervisord.conf /etc/supervisord.conf
COPY ./srcs/setup.sh .

# Make sure that our ssh daemon keeps restarting

RUN chmod +x setup.sh

EXPOSE 5000

CMD [ "sh", "-c", "/tmp/start.sh ; /usr/bin/supervisord -c /etc/supervisord.conf" ]
