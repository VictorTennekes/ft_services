FROM alpine:3.12

RUN	apk add mysql mysql-client gettext

COPY ./srcs/startup.sh /tmp/startup.sh
COPY ./srcs/my.cnf /tmp/
COPY ./srcs/create_tables.sql /tmp/

RUN envsubst ${DB_USER} ${DB_PASSWORD} < /tmp/my.cnf > /etc/my.cnf

RUN chmod +x /tmp/startup.sh
VOLUME /var/lib/mysql

ENTRYPOINT ["/bin/sh", "/tmp/startup.sh"]
