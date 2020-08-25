FROM alpine:3.7

MAINTAINER Victor Tennekes

RUN	apk update && \
	apk upgrade && \
	#apk add openssh
	#apk add supervisor
	apk add nginx

RUN adduser --disabled-password -g 'Nginx www user' - /home/www/ nginx_admin

COPY srcs/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY srcs/nginx/nginx.cert /etc/ssl/localhost.cert
COPY srcs/nginx/nginx.key /etc/ssl/localhost.key

EXPOSE 80 443 22

CMD /usr/sbin/nginx -g "daemon off;"