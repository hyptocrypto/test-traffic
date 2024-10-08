kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.1/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.1/docs/content/reference/dynamic-configuration/kubernetes-crd-rbac.yml

kubectl create namespace traefik
helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install traefik traefik/traefik --namespace traefik
echo "Traefik configured!!\n"

kubectl apply -f deployment/deployment_go_app.yaml
echo "---------------------------\n"
kubectl apply -f deployment/deployment_ringo.yaml
echo "---------------------------\n"
kubectl apply -f deployment/deployment_python_app.yaml
echo "---------------------------\n"
kubectl apply -f deployment/deployment_postgres.yaml
