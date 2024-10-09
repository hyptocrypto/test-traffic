# Install traefik CRD's. Needed to do prefix striping middleware
kubectl create namespace traefik
kubectl create namespace monitoring

# Apply traefik crds
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.1/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.1/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

# Add traefik prometheus and grafana repos
helm repo add traefik https://traefik.github.io/charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy traefik onto the culster
helm install traefik traefik/traefik --namespace traefik --set dashboard.enabled=true --set service.type=ClusterIP --set entryPoints.web.address=:9000
helm upgrade --install traefik traefik/traefik -f deployment/traefik-values.yaml -n traefik
echo "traefik configured!!\n"

# Deploy prometheus onto the culster
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
echo "prometheus configured!!\n"

# Deploy grafana onto the cluster
helm install grafana grafana/grafana --namespace monitoring --set service.type=NodePort --set persistence.enabled=true --set adminPassword='admin'
echo "grafana configured!!\n"

# Deploy demo appls
kubectl apply -f deployment/deployment_go_app.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_ringo.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_python_app.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_postgres.yaml
