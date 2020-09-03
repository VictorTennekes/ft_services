FROM alpine:3.12

LABEL maintainer vtenneke

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache vsftpd curl jq gettext

COPY srcs/vsftpd.conf /tmp/vsftpd.conf
COPY srcs/ftps.cert /etc/ssl/certs/ftps.cert
COPY srcs/ftps.key /etc/ssl/certs/ftps.key
COPY ./srcs/setup.sh /tmp
COPY ./srcs/get_external_ip.sh /tmp

RUN chmod +x tmp/setup.sh
RUN chmod +x /tmp/get_external_ip.sh
RUN adduser -D -h /var/ftp ftps_user && \
	echo "ftps_user:pass" | chpasswd

# 20 Command control
# 21 Data transfer
# 30000 Passive ftp
EXPOSE 20 21 30000

CMD ["sh", "-c", "/tmp/setup.sh"]