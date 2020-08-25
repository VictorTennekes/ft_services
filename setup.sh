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
	docker build -t $1 $2 > /dev/null 2>>errlog.txt && kubectl apply -f $3 > /dev/null 2>>errlog.txt
    RET=$?
	if [ $RET -eq 1 ]
	then
		echo "[${RED}NO${END}]"
	else
		echo "[${GREEN}OK${END}]"
	fi
}
# ---------- Cleanup ---------- #
#rm -rf ~/.minikube
#mkdir -p ~/goinfre/.minikube
#ln -s ~/goinfre/.minikube ~/.minikube

:> errlog.txt
:> log.log
#sh cleanup.sh >> log.log 2>> /dev/null

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

kubectl apply -f ./src/metallb/config.yml
start_app "nginx-alpine" "./src/nginx" "./src/nginx/nginx.yml"