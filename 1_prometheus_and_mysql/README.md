# K8S4Fun #1 - MySQL + WordPress + Prometheus

## What happens here

- MySQL and WordPress deployments borrowed from official K8s tutorial
- Prepared Dockerfile which downloads [MySQL Prometheus Exporter from github](https://github.com/prometheus/mysqld_exporter), compiles it and sets as container entrypoint
- Written k8s deployment which creates the exporter container and connects it to MySQL server
  - Contains also init container which makes sure exporter can access the database server via its own MySQL user account
  - Metrics exposed as a Service
- Written k8s deployment of Prometheus, injecting config file via ConfigMap
  - Configured static scrape of MySQL metrics
  - Prometheus GUI exposed as a service
- All of the above is united in the Kustomization file
  - Included secret generator based on `env` files (in order to keep secrets outside the repository)
  - Secrets are injected into deployments via container env. vars where they're needed

## Deployment

Tested under minikube local cluster. In order for the kustomization to work, we must build the image inside the cluster.
```
eval $(minikube -p minikube docker-env)
docker build . -f Dockerfile-exporter -t mysqld_exporter
```

Next we need to prepare secrets by copying `.env.secret.example` into `.env.secret` and setting database passwords.

After that we can apply kustomization and forward ports to test:
```
kubectl apply -k .
kubectl port-forward service/wordpress 8080:wordpress
kubectl port-forward service/prometheus 9090:prometheus
```

## TODO

- Configure Prometheus to use Service discovery instead of static config
- Try to add some dependencies between deployments - mysqld-exporter deployment should wait until mysql is ready as its init container requires live DB connection