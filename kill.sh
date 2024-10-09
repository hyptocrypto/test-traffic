# Check if the script is running as root, otherwise re-run it with sudo
if [ "$EUID" -ne 0 ]; then
	sudo "$0" "$@"
	exit
fi

sudo pkill "kubectl"

kubectl delete namespaces traefik
kubectl delete namespaces monitoring
kubectl delete -f deployment/deployment_go_app.yaml
kubectl delete -f deployment/deployment_ringo.yaml
kubectl delete -f deployment/deployment_python_app.yaml
kubectl delete -f deployment/deployment_postgres.yaml
