FROM alpine:3.12

LABEL maintainer vtenneke

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add --no-cache vsftpd

COPY src/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY src/ftps.cert /etc/ssl/certs/ftps.cert
COPY src/ftps.key /etc/ssl/certs/ftps.key

RUN mkdir -p /var/ftp && \
	adduser -D -h /var/ftp ftps_user && \
	echo "ftps_user:pass" | chpasswd

# 20 Command control
# 21 Data transfer
# 30000 Passive ftp
EXPOSE 20 21 30000

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]