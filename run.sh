helm repo add traefik https://traefik.github.io/charts &&
helm repo update &&
helm install traefik traefik/traefik &&
kubectl apply -f deployment/deployment_go_app.yaml
kubectl apply -f deployment/deployment_python_app.yaml
kubectl apply -f deployment/deployment_postgres.yaml
