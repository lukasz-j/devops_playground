# Puppet4Fun #1 - Nginx + PHP

## What happens here

- Simple puppet environment inside Docker containers based on Debian 11
- One server and 2 nodes
- Puppet's SSL and environment arranged as docker volumes so configuration and agent->server bindings survive container recreation
- Each node is configured to have Nginx+PHP and serve some example content
- configuration makes simple use of Facts - hostname is injected into index HTML file

## Deployment

Build containers:

```
docker build . -f Dockerfile-base -t puppet-base:1
docker build . -f Dockerfile-server -t puppet-server:1
docker build . -f Dockerfile-node -t puppet-node:1
```

Then start the compose (`docker compose up -d`). When containers are up, attach to both nodes (`docker compose exec puppet-node1 bash`) and initialize SSL (`puppet ssl bootstrap`). When CSR is ready, in another terminal attach to server and sign CSR (`puppetserver ca sign --all`). Repeat for the second node. When this is done, you can apply catalog for both nodes (`puppet agent -t`).

When this is done and Puppet catalog is applied, you should be able to access both nodes' nginx at `localhost:9080` and `localhost:9081`.