FROM alpine:3.12

RUN mkdir -p /run/nginx

RUN apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache php7-common php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session php7-phar php7-cli php7-zip php7-iconv php7-xml php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom\
    wget \
    curl \
    jq \
    gettext \
    nginx\
    supervisor

RUN adduser -D -g 'www' www
RUN mkdir /www

COPY ./srcs/wp-config.php /tmp/wp-config.php
COPY ./srcs/wpinstall.sh /tmp/wpinstall.sh
COPY ./srcs/nginx.conf /etc/nginx/nginx.conf
COPY ./srcs/supervisord.conf /etc/supervisord.conf
COPY ./srcs/*.sh /tmp/

# Make sure that our ssh daemon keeps restarting
RUN sed -i 's/;daemonize = yes/daemonize = no/g' /etc/php7/php-fpm.conf

RUN chmod +x /tmp/*.sh
EXPOSE 5050

CMD [ "sh", "-c", "/tmp/start.sh ; /usr/bin/supervisord -c /etc/supervisord.conf" ]