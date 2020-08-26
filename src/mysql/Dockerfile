FROM alpine:3.12

RUN	apk add mysql mysql-client

COPY ./srcs/startup.sh /tmp/startup.sh
COPY ./srcs/my.cnf /etc/

RUN chmod +x /tmp/startup.sh
VOLUME /var/lib/mysql

ENTRYPOINT ["/bin/sh", "/tmp/startup.sh"]
