# Infrastructure Skeleton

Should infrastructure code live alongside the application code,
or separate from the application?

There are merits (and pitfalls) to both.
This is how you might structure a project if you want or need your container and infrastructure code to live with
your application code.

For now, this is a real rough sketch, and mostly just a collection of thoughts.

## Built With

*   [Kubernetes](https://kubernetes.io/) - Automated container deployment, scaling, and management
*   [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) - Kubernetes object
    management
*   [Docker](https://www.docker.com/) - App containerization
*   [NodeJS](https://nodejs.org) - Javascript runtime

## Getting Started

There are several ways you can configure the application.
I already assume that you know how to run a NodeJS application locally,
and how to run and access the application inside a Docker container.

The purpose of this project is to explore application infrastructure management with Kubernetes,
so the following instructions will guide you in setting up a local Kubernetes cluster running a demo "hello world" 
NodeJS application inside a single pod within your node,
and how to access the demo application. 

### Prerequisites

*   [Docker](https://docs.docker.com/get-docker/) - Click the link for specific setup instructions on your machine's
    operating system (Docker Desktop for macOS/Windows, Docker Engine for Linux).
*   Kubernetes via
    [Docker Desktop](https://docs.docker.com/docker-for-mac/#kubernetes) or
    [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) - Because I am running macOS with Docker
    Desktop, which includes a standalone Kubernetes server and client,
    I prefer enabling Kubernetes via Docker Desktop.
    If you prefer or aren't able to run Kubernetes in this way,
    Minikube is a great choice.

### Deploying Locally

Assuming you have followed the prerequisite steps to installing Docker and Kubernetes,
we can begin.

1.  In your terminal,
    ensure Kubernetes is running.

    ```shell script
    kubectl help
    ```

    The output should be a list of commands you can pass to Kubernetes Control (`kubectl`).
    
1.  Build the demo container image locally.

    ```shell script
    bash ./scripts/build_images.sh
    ```

    This script uses the `docker build` command to build our image `demo` with tag `dev`.
    After the script runs,
    you can see the image by running `docker images`,
    which will output something like this.
    
    ```shell script
    REPOSITORY               TAG                   IMAGE ID            CREATED             SIZE
    demo                     dev                   ba96286b5ac9        2 days ago          918MB
    ...
    ```

1.  Load the infrastructure described in the various configuration files in the `kubernetes/local/bases/` directory.

    ```shell script
    kubectl kustomize kubernetes/local/bases/ | kubectl apply -f -
    ```

    [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/) is a standalone tool that
    allows you to customize Kubernetes configurations and is [included](https://github.com/kubernetes-sigs/kustomize)
    with Kubernetes.
    
1.  At this point the application should be deployed and running inside a pod on your local Kubernetes node.
    You can confirm this with the following commands.
    
    ```shell script
    kubectl get pods
    ```
    
    Which should output something like this.
    
    ```shell script
    NAME                              READY   STATUS    RESTARTS   AGE
    demo-deployment-dd886b68b-jl6mp   1/1     Running   0           3m
    ```

    If you are feeling adventurous,
    you can access a shell directly on the pod.
    
    ```shell script
    kubectl exec -it deploy/demo-deployment  -- /bin/bash
    ```
    
    This will drop you on a shell where you can explore the pod,
    and the application code that was loading into the container.
    
1.  The service is configured to expose the pod's `3000` port so that it can be interacted with in your local
    browser window.
    
    To find the local port on which you can access the pod,
    print out the service information.
    
    ```shell script
    kubectl get svc
    ```
    
    Which should output something like this.
    
    ```shell script
    NAME           TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    demo-service   NodePort   10.101.234.185   <none>        3000:30189/TCP    3m
    ```

1.  Navigate to `localhost:30189` (in this example) in your favorite browser,
    and you should be greeted with the message "hello world".

## Project Structure

One goal of this project was to dive in and understand how to use Kubernetes using a simple application example.
The other goal was to come up with a sane way to organize infrastructure code alongside the application's code.

```shell script
.
├── aws
├── ci
├── docker
├── kubernetes
│   ├── bases
│   │   └── kustomization.yaml
│   └── overlays
│       ├── dev
│       │   └── kustomization.yaml
│       ├── prod
│       │   ├── bases
│       │   │   └── kustomization.yaml
│       │   ├── us-central
│       │   │   └── kustomization.yaml
│       │   ├── us-east
│       │   │   └── kustomization.yaml
│       │   └── us-west
│       │       └── kustomization.yaml
│       ├── staging
│       │   ├── bases
│       │   │   └── kustomization.yaml
│       │   └── us-west
│       │       └── kustomization.yaml
│       └── test
│           ├── kustomization.yaml
│           └── namespace.yaml
├── scripts
└── src
```
