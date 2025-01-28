## Azure Kubernetes Resume Challenge ##

This is inspired by the (https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/)

## Setup ##
Prerequisites

- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
- [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
- [Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure)

## Getting Started ##
1. [Install and configure Kubernetes using Terraform](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)
2. Create & Deploy K8s Manifests
- `kubectl apply -f k8s/ecom-db/mariadb-deployment.yaml`
- `kubectl apply -f k8s/ecom-webapp/website-deployment.yaml`
3. Check newly created pods
- `kubectl get pods`