---
title: "Deployment"
linkTitle: " Deployment"
description: >
  Learn how to deploy Trickster for your project.
---

## Docker

```
$ docker run --name trickster -d [-v /path/to/trickster.yaml:/etc/trickster/trickster.yaml] -p 0.0.0.0:9090:9090 trickstercache/trickster:latest
```

## Kubernetes, Helm, RBAC

{{< alert type="success" >}}
For helpful example files, see [trickster/deploy](https://github.com/trickstercache/trickster/tree/main/deploy).
{{< /alert >}}

If you want to use Helm and kubernetes rbac, use the following install steps in the `deploy/helm` directory.

#### Bootstrap Local Kubernetes-Helm Dev

1. Install [Helm](https://helm.sh/docs/intro/install/) **Client Version 2.9.1**
    ```
    brew install kubernetes-helm
    ```

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) **client server 1.13.4, client version 1.13.4**
    ```
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.4/bin/darwin/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
    ```

1. Install [minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) **version 0.35.0**
    ```
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.23.2/minikube-darwin-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    ```

1. Start minikube and enable RBAC `make start-minikube` or manually with `--extra-config=apiserver.Authorization.Mode=RBAC --kubernetes-version=v1.8.0`.
1. Install Tiller `make bootstrap-peripherals`
1. Wait until Tiller is running `kubectl get po --namespace trickster -w`
1. Deploy all K8 artifacts `make bootstrap-trickster-dev`

#### Deployment

1. Make any necessary configuration changes to `deploy/helm/values.yaml` or `deploy/helm/template/configmap.yaml`
1. Set your kubectl context to your target cluster `kubectl config use-context <context>`
1. Make sure Tiller is running `kubectl get po --namespace trickster -w`
1. Run deployment script `./deploy` from within `deploy/helm`

## Kubernetes

{{< alert type="success" >}}
For helpful kubernetes deployment example files, see [trickster/deploy/kube](https://github.com/trickstercache/trickster/tree/main/deploy/kube).
{{< /alert >}}

#### Bootstrap Local Kubernetes Dev

1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) **client server 1.8.0, client version 1.8.0**
    ```
    brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/e4b03ca8689987364852d645207be16a1ec1b349/Formula/kubernetes-cli.rb
    brew pin kubernetes-cli
    ```

1. Install [minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) **version 0.25.0**
    ```
    brew cask install https://raw.githubusercontent.com/caskroom/homebrew-cask/903f1507e1aeea7fc826c6520a8403b4076ed6f4/Casks/minikube.rb
    ```

1. Start minikube `make start-minikube` or manually with `minikube start`.
1. Deploy all K8 artifacts `make bootstrap-trickster-dev`

#### Deployment

1. Make any necessary configuration changes to `deploy/kube/configmap.yaml`
1. Set your kubectl context to your target cluster `kubectl config use-context <context>`
1. Run deployment script `./deploy` from within `deploy/kube`

## Local Binary
#### Binary Dev

1. Use parent directory and run make, then `./trickster [-config <path>]`
