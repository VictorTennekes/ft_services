# [ft_services](https://www.youtube.com/watch?v=d8ekz_CSBVg)
> :warning:	**DISCLAIMER!**

Ft_services is a demanding and resource intensive project, minikube and its dependencies/components can be run on windows, but Linux/Mac OS is recommended.

It is also recommended to have at least *8GB* of RAM on your system.

## Index
* [Introduction](#introduction)
* [Objects](#objects)
* [Minikube Introduction](#minikube-introduction)
* [Commands](#commands)
* [Quick Start Guide](#quick-start-guide)

## Introduction
Ft_services consists of setting up an infrastructure of different services using Kubernetes. All the containers of these services should be built using [Alpine Linux](https://www.alpinelinux.org/) for performance reasons. The entire project should build itself with a *setup.sh* file.

> :warning: **It is forbidden to use prebuilt images or use services like DockerHub.**

Kubernetes (κυβερνήτης, Greek for “[Helmsman](https://en.wikipedia.org/wiki/Helmsman)” or “pilot”) is an automatization/orchestration tool to deploy and manage containerized workloads and services. That might sound and look daunting, since it's not like anything we are used to dealing with.

But it's actually very doable and quite easy once you've gotten the hang of it.

## Objects
**[Cluster](https://kubernetes.io/docs/tasks/administer-cluster/cluster-management/)**<br>
Collective term for the entirety of our running kubernetes setup (all machines/nodes).

**[Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)**<br>
How kubernetes refers to physical/virtual machines that our cluster is running on.

**[Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)**<br>
You can view this as a group of one or more pods, based on its settings it will create one or more pods and manage their state (recreation in case of fail etc).

**[Pods](https://kubernetes.io/docs/concepts/workloads/pods/)**<br>
A Pod is a group of one or more containers.

**[Container](https://kubernetes.io/docs/concepts/containers/)**<br>
Information and details of the container we'll be running.<br>
The image we'll be running on the container, that's refered to by the tag you've given it.<br>
By default the imagePullPolicy is set to `Always`, since normally you would pull images from a repository, we'll need to override this and set it to `Never`.<br>
There are many optional settings we can supply aswell, for example:
- You can mount things on the container, such as persistentvolumes or configmaps.
- You can add environment variables to the container.
- You can run probes on the container to check the health or other state related things.

**[Secret](https://kubernetes.io/docs/concepts/configuration/secret/)**<br>
Secrets let you store sensitive information, such as user credentials and passwords.<br>
It can be referenced to create an environment variable from the secret.

**[Service](https://kubernetes.io/docs/concepts/services-networking/service/)**<br>
A reliable way to expose an application as a network service using an external IP adress or a clusterIP (virtual IP used to communicate between pods).<br> It is possible to communicate between pods without a service, but you would be required to have the clusterIP of the pod in question.
By making a service and setting up the matchLabel selector we can now connect to the clusterIP of the service by using the service name as that will resolve to the clusterIP. (and that will in turn connect us through to the pod thats connected to the service)

Subtypes include:
| Type         | Description                                                                                                   |
|--------------|---------------------------------------------------------------------------------------------------------------|
| [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) | Connect to the internal loadbalancer (metallb in our case) to request an external IP address for the service. |
| [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types)    | Default service, only used to communicate from pod to pod.                                                    |
| [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#nodeport)     | Bind the service to a port on the node's external IP (something we're not allowed to use).                    |

**[Configmap](https://kubernetes.io/docs/concepts/configuration/configmap/)**<br>
Dedicated object used to store configuration settings, both for internal processes (metalLB), and also configurations of our docker hosted applications (nginx, phpmyadmin, wordpress etc).

**[Role](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-example)**<br>
Permissions, that's all they are. Permissions relating to the kubernetes API.

**[Rolebind](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding)**<br>
Connecting the subject (an account, serviceaccount etc..) to the permissions (the role).

**[Serviceaccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)**<br>
User that's associated with pods, by default there exists one service account named 'default' that is automatically associated with every pod that gets created, if nothing else is specified.

**[PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)**<br>
Storage that will persist between pod crashes, as its lifetime is independent of the pod.

**[PersistentVolumeClaim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)**<br>
Used to bind a PersistentVolume with a pod.

## Minikube Introduction
[Minikube](https://kubernetes.io/docs/setup/learning-environment/minikube/) is a way to host a kubernetes cluster, this variant will only have 1 node, as opposed to [kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) which is used to host a cluster consisting of multiple nodes.<br>
When starting the minikube cluster we can supply a bunch of arguments, some relating to resource usage which you can sort of tune to your liking.<br>
What we're most interested in are the addons that minikube has to offer, all of these could be installed through different steps as well, but we're going to take advantage of the fact that we're running minikube and enable them from the start.
| Type           | Description                                                                                                 |
|----------------|-------------------------------------------------------------------------------------------------------------|
| [MetalLB](https://metallb.universe.tf/configuration/)        | the LoadBalancer we'll be using to create external IP addresses for us.                                     |
| [Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)      | the kubernetes dashboard. (that we can open up with  `minikube dashboard` ).                                |
| [Metrics-Server](https://github.com/kubernetes-sigs/metrics-server) | this will make sure metrics are collected about our cluster and can be accessed through the kubernetes API. |

`--extra-config=kubelet.authentication-token-webhook=true`<br>
This allows us to authenticate our request to the kubernetes API with the service account's bearer token that's placed into every container by default.

## Commands
The main commands we'll be using to interact with our cluster are:

#### `eval $(minikube docker-env)`<br>
Connects us to the docker environment running in the cluster (so that when we build an image, it can actually be found by the deployment).

#### `kubectl logs OBJECT_TYPE NAME`<br>
Shows us logs of the specified object.<br>
We'll mainly use this with the `deployment` object, as it will refer to the pod running under the deployment.

#### `kubectl get OBJECT_TYPE`<br>
Lists all objects of that specific type and shows their general status.

#### `kubectl describe OBJECT NAME`<br>
Gives us detailed information about the specified object.

#### `kubectl create OBJECT_TYPE`<br>
Create an object of the specified type.<br>
Default use of this command would create an object of this type, with the options we give it,
however it is recommended to use yml files for the configurations instead. Luckily this same command can be used to do just that!<br>

You can use `--help` pretty much anywhere with the kubectl create to give you more information on what the type of object requires.<br>
`kubectl create deployment --help` for example

By specifying `--dry-run=client` and `-o yaml` we make sure it doesnt actually create an object (as we might want to change some of the settings later)
and instead we'll output the objects details in yml format instead.

#### `kubectl delete OBJECT OBJECT_NAME`<br>
delete the object of the specified type. for example `kubectl delete svc wordpress`.<br>
You can also use `--all` instead of `OBJECT_NAME`.
> :warning: Using `--all` is not recommended with `svc` as `OBJECT` as this will destroy your kubernetes service, which results in the demise of your cluster. You will have to `minikube delete` and rerun `setup.sh`.

## Quick Start Guide
1. Create a dockerfile, add the base image with the `FROM` tag and built it with `docker build -t IMAGENAME`.
2. Google how to install the desired application on *Alpine Linux* and try to run it using `docker run -it IMAGENAME`.
3. Look up what configuration you would need for your application to run as desired.
4. [Work](https://www.youtube.com/watch?v=UbxUSsFXYo4).
5. Implement the installation and configuration of the application into your Dockerfile.
6. Create a deployment and a service (using `kubectl create`).
7. Create any other objects you might need.