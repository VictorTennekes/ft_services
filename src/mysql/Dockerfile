FROM alpine:3.12

RUN	apk add mysql mysql-client

COPY ./src/startup.sh /tmp/startup.sh
COPY ./src/my.cnf /etc/
COPY ./src/create_tables.sql /tmp/

RUN chmod +x /tmp/startup.sh
VOLUME /var/lib/mysql

ENTRYPOINT ["/bin/sh", "/tmp/startup.sh"]
