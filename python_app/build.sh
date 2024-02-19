docker build . -t python-app &&
docker tag python-app:latest germanp34e/python-app:latest &&
docker push germanp34e/python-app:latest
