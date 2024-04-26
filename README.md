## Simple app to test [traefik](https://github.com/traefik/traefik) as a K8s ingress/gateway

### Run locally
* Have helm and some k8s cluster running, DockerDesktop or Minikube work well. 
* Run the start script. This will helm install traefik and install some demo apps & config.
```shell
/bin/bash run.sh
```
* Forward the necessary ports, 8000 for http and 9000 for the dashboard. (As separate processes)
```shell
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000
kubectl port-forward $(kubectl get pods --selector "app.kubernetes.io/name=traefik" --output=name) 8000:8000
```
There will be two simple wep apps running. A Golang app that is under the api namespace /go. And a Python app running under the api namespace /python. Traefik will route requests to the respective application under the same host name (127.0.0.1). 
