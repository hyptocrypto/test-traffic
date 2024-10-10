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

# Deploy prometheus onto the culster
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

# Deploy grafana onto the cluster
helm install grafana grafana/grafana --namespace monitoring --set service.type=NodePort --set persistence.enabled=true --set adminPassword='admin'

# Wait for all core services to be ready
kubectl wait --namespace traefik --for=condition=available --timeout=120s deployment/traefik
echo "Traefik service is ready.\n"
kubectl wait --namespace monitoring --for=condition=available --timeout=120s deployment/grafana
echo "Grafana service is ready.\n"
kubectl wait --namespace monitoring --for=condition=available --timeout=120s deployment/prometheus-kube-prometheus-operator
echo "Prometheus service is ready.\n"

echo "Forwarding ports...\n"
sudo kubectl port-forward -n traefik svc/traefik 80:80 >/dev/null 2>&1 &
kubectl port-forward -n monitoring svc/grafana 3000:80 >/dev/null 2>&1 &
kubectl port-forward -n monitoring service/prometheus-kube-prometheus-prometheus 9090:9090 >/dev/null 2>&1 &

# Deploy demo apps
kubectl apply -f deployment/deployment_go_app.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_ringo.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_python_app.yaml
echo "\n---------------------------\n"
kubectl apply -f deployment/deployment_postgres.yaml
