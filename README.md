# Azure Kubernetes Resume Challenge

## Introduction

This is a high-level architecture of the Ecommerce Web Application deployed in **Azure Kubernetes Service** (AKS) by following a *build specification* specified in the [Kubernetes Resume Challenge - KRC](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/). 

### Mods

- Automate Infrastructure provisionioning of the Kubernetes Cluster with Terraform.
- Include a website banner to test new deployment of the webapp.

### Future Mods

- Introduce **Karpenter** to dynamically scale the Kubernetes cluster based on demand.
- Leverage **Podman** to run a daemonless container engine and improve security because it runs a rootless container.

![aks-ecomm-webapp](./assets/images/aks_cluster_westus1.png)

## Setup

## Prerequisites

1. Configure [az cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt).
2. Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/).
3. Install [Terraform](https://learn.microsoft.com/en-us/azure/developer/terraform/quickstart-configure).
4. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/).
5. Read the [Challenge prerequisites](https://cloudresumechallenge.dev/docs/extensions/kubernetes-challenge/#challenge-guide).

## Quick Start Guide

1. Setup Azure storage as the backend for `*.tfstate` file.

    - Traverse to `infra/prerequisites` dir. 
    - Run `terraform apply -auto-approve` 

2. [Install and configure Kubernetes using Terraform](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli)

    - Traverse to `infra` dir.
    - Run `Terraform apply --auto-approve`

3. Build & Deploy the K8s Manifest file for ecommerce webapp and database.

    This will run all the manifests file:
    - `kubectl apply -f k8s/ecom-db/`
    - `kubectl apply -f k8s/ecom-webapp/`

4. Check the newly created pods.

    - `kubectl get pods`

5. Access the ecommerce website by checking the `external-ip` of the `web-service`

    - `kubectl get service`
    - `http://<external-ip>:<port>`

    ![E-commerce webapp](./assets/images/kk_ecom_webapp.png)

## Package the E-Commerce Webapp and MariadDB with Helm.

### Install Helm

1. [From script](https://helm.sh/docs/intro/install/#from-script).
2. Intialse the project directory `helm create ecom-webchart`

This will create the correct `dir` structure for helm charts:

```bash
├── Chart.yaml
├── charts
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

In this case I've removed everything from the `templates/` dir and just moved all my manifests file here then converted them into helm templates and parameters for the ecom-webapp.

3. Helm *workflow* - A typical output that's expected if the templates are formed correctly.

```bash
$ helm lint ecom-web-chart/

==> Linting ecom-web-chart/
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed

$ helm template ecom-web-chart/

...
# Source: ecom-web-chart/templates/ecom-webapp/website-hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: website-hpa
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ecommWebsiteDeployment
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50

$ helm install release-1 ecom-web-chart/

NAME: release-1
LAST DEPLOYED: Sun Feb  2 16:43:06 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None

```

4. Check the website after new changes are applied. So, in this instance a *banner* is deployed to notify users that there's a
**Special Offer**.

![E-commerce webapp-w-banner](./assets/images/kk_ecom_webapp_banner.png)

5. Manually Test the autoscaling of applications this can be done via `kubectl` or `helm`.
```bash

$ kubectl scale deployment/ecomm-website-deployment --replicas=6
deployment.apps/ecomm-website-deployment scaled

$ kubectl scale deployment/mariadb-deployment --replicas=3
deployment.apps/mariadb-deployment scaled

$ kubectl get po

NAME                                       READY   STATUS              RESTARTS   AGE
ecomm-website-deployment-f5d7c58cb-dtj8c   1/1     Running             0          2m41s
ecomm-website-deployment-f5d7c58cb-hggqn   1/1     Running             0          2m41s
ecomm-website-deployment-f5d7c58cb-hhwjg   1/1     Running             0          2m41s
ecomm-website-deployment-f5d7c58cb-jp5qd   1/1     Running             0          12h
ecomm-website-deployment-f5d7c58cb-qxpt8   1/1     Running             0          2m41s
ecomm-website-deployment-f5d7c58cb-xrw2k   1/1     Running             0          2m41s
mariadb-deployment-796dcf5898-4lnn8        0/1     ContainerCreating   0          4s
mariadb-deployment-796dcf5898-bj8f7        1/1     Running             0          4s
mariadb-deployment-796dcf5898-h6zjc        1/1     Running             0          12h

$ helm upgrade --set replicaCount=2 release-1 ecom-web-chart

Release "release-1" has been upgraded. Happy Helming!
NAME: release-1
LAST DEPLOYED: Mon Feb  3 09:52:46 2025
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
```

## Create a CI/CD pipeline to automate the deployment process.
- This pipeline will automatically trigger when:
  - An updated image is pushed in Docker hub.
  - A New feature is released for the Ecommerce website.

- Create a GHA workflow similar [here](https://github.com/araxia55/azure-kubernetes-resume-challenge/blob/36d8c45890b220e5c7a6f03e9b4d1d54c0f8562f/.github/workflows/deploy-ecom.yml).

Sample pipeline:
![gha-workflow](./assets/images/gha-workflow.png)

## Create an Automatic Code Scan and upload the results in Github for remediation.
- Included [**Codeql**](https://github.com/github/codeql-action/tree/v3) to automatically scan the repo for vulnerabilities.

![codeql-scan01](./assets/images/codeql-scan01.png)

## Cleanup everything.

```bash
helm uninstall release-1 ecom-web-chart/
release "release-1" uninstalled
```

Then traverse to `infra/` dir.

`$ terraform destroy --auto-approve`