## Azure Kubernetes Resume Challenge ##

This is inspired by the [**Kubernetes Resume Challenge**](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/).

## Setup ##
Prerequisites

- [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/)
- [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
- [Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure)

## Getting Started ##
1. Setup Azure storage as the backend for `*.tfstate` file. 
- Traverse to `infra/prerequisites` dir. 
- Run `terraform apply -auto-approve` 
2. [Install and configure Kubernetes using Terraform](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)
- Traverse to `infra` dir.
- Run `Terraform apply --auto-approve`
3. Create & Deploy the K8s Manifest file for ecommerce webapp and database.
- `kubectl apply -f k8s/ecom-db/`
- `kubectl apply -f k8s/ecom-webapp/`
4. Check newly created pods.
- `kubectl get pods`
5. Access the ecommerce website by checking the external ip of the `web-service`
- `kubectl get service`
6. Setup Apache Bench