FROM alpine:3.12

LABEL maintainer vtenneke

RUN	apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache nginx \
	openssh \
	supervisor

RUN adduser -D -g 'www' www && \
	mkdir /www && \
	chown -R www:www /var/lib/nginx && \
	chown -R www:www /www & \
	mkdir -p /var/run/nginx

RUN ssh-keygen -A

COPY srcs/nginx.conf /etc/nginx/conf.d/default.conf
COPY srcs/UVA-Homepage/index.html /www/index.html
COPY srcs/nginx.cert /etc/ssl/localhost.cert
COPY srcs/nginx.key /etc/ssl/localhost.key
COPY srcs/supervisord.conf /etc/supervisord.conf
COPY ./srcs/*.sh /tmp/

RUN chmod +x /tmp/*.sh

EXPOSE 80 443 22

CMD ["sh", "-c", "/tmp/setup.sh ; /usr/bin/supervisord -c /etc/supervisord.conf"]