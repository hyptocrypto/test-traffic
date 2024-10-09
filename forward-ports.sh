echo "Forwarding ports..."
sleep 1
sudo kubectl port-forward -n traefik svc/traefik 80:80 >/dev/null 2>&1 &
sleep 1
kubectl port-forward -n monitoring svc/grafana 3000:80 >/dev/null 2>&1 &
sleep 1
kubectl port-forward -n monitoring service/prometheus-kube-prometheus-prometheus 9090:9090 >/dev/null 2>&1 &
sleep 1
kubectl port-forward -n traefik $(kubectl get pods -n traefik -l "app.kubernetes.io/name=traefik" -o jsonpath='{.items[0].metadata.name}') 9000:9000 >/dev/null 2>&1 &
