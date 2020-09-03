FROM alpine:3.12

LABEL maintainer vtenneke

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache vsftpd curl jq gettext

COPY srcs/vsftpd.conf /tmp/vsftpd.conf
COPY srcs/ftps.cert /etc/ssl/certs/ftps.cert
COPY srcs/ftps.key /etc/ssl/certs/ftps.key
COPY ./srcs/*.sh /tmp/

RUN chmod +x tmp/*.sh
RUN mkdir -p /var/ftp

# 20 Command control
# 21 Data transfer
# 30000 Passive ftp
EXPOSE 20 21 30000

CMD ["sh", "-c", "/tmp/setup.sh"]