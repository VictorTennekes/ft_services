FROM alpine:3.12

LABEL maintainer vtenneke

RUN apk update --no-cache && \
	apk upgrade --no-cache && \
	apk add grafana --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ && \
	apk add sed --no-cache && \
	apk add curl --no-cache

WORKDIR /usr/share/grafana

COPY srcs/default.yaml /usr/share/grafana/conf/provisioning/datasources/
COPY srcs/dashboards/*.json /usr/share/grafana/conf/provisioning/dashboards/mine/
COPY srcs/dashboards/default.yaml /usr/share/grafana/conf/provisioning/dashboards/

EXPOSE 3000

CMD [ "grafana-server", "web" ]