#!/bin/bash

# ---------- Colors ---------- #
RED=$'\e[1;31m'
GREEN=$'\e[1;32m'
YELLOW=$'\e[1;33m'
BLUE=$'\e[1;34m'
MAGENTA=$'\e[1;35m'
CYAN=$'\e[1;36m'
END=$'\e[0m'

# ---------- Modular function for starting apps ---------- #
# $1 = name, $2 = docker-location, $3 = yml-location
start_app () {
	printf "$1: "
	if [ "$4" == "--debug" ]
	then
		docker build -t $1 $2 && kubectl apply -f $3
	else
		docker build -t $1 $2 > /dev/null 2>>errlog.txt && kubectl apply -f $3 > /dev/null 2>>errlog.txt
	fi
    RET=$?
	if [ $RET -eq 1 ]
	then
		echo "[${RED}NO${END}]"
	else
		echo "[${GREEN}OK${END}]"
	fi
}

# ---------- Setting debug ---------- #
DEBUG=$""
if [ $# -eq 1 ]
then
    DEBUG="--debug"
fi

# ---------- Cleanup ---------- #
#rm -rf ~/.minikube
#mkdir -p ~/goinfre/.minikube
#ln -s ~/goinfre/.minikube ~/.minikube

:> errlog.txt

# ---------- Cluster start ---------- #
minikube start --driver=virtualbox \
				--cpus=2 --memory=2048 --disk-size=10g \
				--addons metallb \
				--addons default-storageclass \
				--addons dashboard \
				--addons storage-provisioner \
				--addons metrics-server \
				--extra-config=kubelet.authentication-token-webhook=true

# ---------- Build and deploy ---------- #
eval $(minikube docker-env)
export MINIKUBE_IP=$(minikube ip)

kubectl apply -f ./srcs/metallb/config.yml
kubectl apply -f ./srcs/read_service_permissions.yml
start_app "nginx" "./srcs/nginx" "./srcs/nginx/nginx.yml" $DEBUG
start_app "ftps" "./srcs/ftps" "./srcs/ftps/ftps.yml" $DEBUG
start_app "mysql" "./srcs/mysql" "./srcs/mysql/mysql.yml" $DEBUG
start_app "wordpress" "./srcs/wordpress" "./srcs/wordpress/wordpress.yml" $DEBUG
start_app "phpmyadmin" "./srcs/phpmyadmin" "./srcs/phpmyadmin/phpmyadmin.yml" "$DEBUG"
start_app "influxdb" "./srcs/influxdb" "./srcs/influxdb/influxdb.yml" "$DEBUG"
start_app "telegraf" "./srcs/telegraf" "./srcs/telegraf/telegraf.yml" "$DEBUG"
start_app "grafana" "./srcs/grafana" "./srcs/grafana/grafana.yml" "$DEBUG"
