FROM alpine:3.12

LABEL maintainer vtenneke

RUN	apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache nginx

RUN adduser -D -g 'www' www && \
	mkdir /www && \
	chown -R www:www /var/lib/nginx && \
	chown -R www:www /www & \
	mkdir -p /var/run/nginx

COPY src/nginx.conf /etc/nginx/conf.d/default.conf
COPY src/UVA-Homepage/index.html /www/index.html
COPY src/nginx.cert /etc/ssl/localhost.cert
COPY src/nginx.key /etc/ssl/localhost.key

EXPOSE 80 443 22

CMD nginx -g "daemon off;"