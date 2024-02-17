docker build . -t go-app &&
docker tag go-app:latest germanp34e/go-app:latest &&
docker push germanp34e/go-app:latest
