kubectl delete namespaces traefik
kubectl delete -f deployment/deployment_go_app.yaml
kubectl delete -f deployment/deployment_ringo.yaml
kubectl delete -f deployment/deployment_python_app.yaml
kubectl delete -f deployment/deployment_postgres.yaml
