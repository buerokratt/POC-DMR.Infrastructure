# Helm/Helm charts
This document outlines a high-level overview of Helm charts and how Helm charts will be used to deploy our services to Kubernetes. This document assumes you would have basic understanding of how manifest files work when deploying a resource to a Kubernetes cluster. As part of this documentation, there has also been an example Helm chart repo created here under the directory '../mock-classifier-helm-chart-example'.

## What is Helm?
Helm is a Kubernetes deployment tool for automating creation, packaging, configuration, and deployment of applications and services to Kubernetes clusters. Essentially, imagine Helm as a package manager for the Kubernetes system much like choco is for Windows, and the packages we install are the apps and services we want to deploy onto the Kubernetes cluster. For further reading please see the official documentation here: https://helm.sh/docs/.

## Why Helm?
Imagine we want to deploy a container image to the Kubernetes cluster that will have three replica pods and a service load balancer, we would typically need to create a series of manifest files which will describe these resources then run the 'kubectl apply' command against the respective files to deploy the resources to Kubernetes. It becomes tricky to manage these files manually, having many different manifest files unstructured in a repo and a lot of replicated code within these manifest files with little control over them. Helm essentially provides us with an easy and efficient way to package these files, version them, view history and hence be able to roll-back or upgrade our Kubernetes cluster in accordance with the files and the configuration they specify. Just like Docker gives us the flexibility to choose which version of an image of an app/service we want to run, Helm provides that same flexibility when it comes to running a particular version of a chart, of a specific configuration.

## What is a Helm chart?
A Helm chart is a collection of files that describe a related set of Kubernetes resources. A single chart might be used to deploy something simple, like a memcached pod, or something complex, like a full web app stack with HTTP servers, databases, caches, and so on. Below describes the file structure of the chart and its contents.

```
chart-name                  
├── .helmignore
├── Chart.yaml
├── values.yaml
├── charts
│   └── ...
├── templates
│   └── ...
├── crds 
│   └── ...
```

chart-name/:
This is the folder that contains your chart.

.helmignore (file):
This is the file that contains all the ignored files when packaging the chart, like gitignore.   

Chart.yaml (file):
This is the file that contains metadata/information about the chart that is being packaged e.g. version no., name of chart etc.

values.yaml (file):
This is the file that contains all the values you want to inject into your templates. Think of this as Helm's version of Terraform's variables.tf file. This is where the magic happens when it comes to versioning, every time you make a change to the chart or app you upgrade the version number variables in here which will create the basis for rolling/upgrading this Helm deployment in the Kubernetes cluster.

charts/:
This is the folder that contains other library charts that your chart depends on.

templates/:
This is the folder that contains the actual manifest files (yaml) that you are deploying with the chart. For example you might be deploying an nginx deployment that needs a service, configmap and secrets. You will have your deployment.yaml, service.yaml, config.yaml and secrets.yaml all in the template repo. They will all get their values from values.yaml from above.

crds/ (repo):
This is the folder that contains the custom resource definitions.             
    
## Helm commands
Helm commands provides us with a set of powerful and useful commands that helps to create, manage, install, deploy, roll back, etc our charts. Firstly, the helm CLI needs to installed on the machine, below is a list of useful and basic helm commands.

Install an app:
helm install [app-name] [chart]

Upgrade an app:
helm upgrade [release] [chart]

Roll back a release:
helm rollback [release] [revision]

Create a chart (repo):
helm create [name]

Package a chart into a chart archive:
helm package [chart-path]

Checks if the chart is well-formed and catches out potential bugs:
helm lint [chart-path]

## Proposed solution/integration with Helm/Helm charts
The proposed solution is to create a Helm chart for each of the component repos, which are the mock classifier, mock bot, DMR and centops within the infrastructure repo as follows:

```
mock-classifier                  
├── .helmignore
├── Chart.yaml
├── values.yaml
├── charts
│   └── ...
├── templates
│   └── ...
├── crds 
│   └── ...
mock-bot                 
├── .helmignore
├── Chart.yaml
├── values.yaml
├── charts
│   └── ...
├── templates
│   └── ...
├── crds 
│   └── ...
centops                 
├── .helmignore
├── Chart.yaml
├── values.yaml
├── charts
│   └── ...
├── templates
│   └── ...
├── crds 
│   └── ...
dmr                 
├── .helmignore
├── Chart.yaml
├── values.yaml
├── charts
│   └── ...
├── templates
│   └── ...
├── crds 
│   └── ...
```

This proposed repo structure as opposed to having each chart within their own respective repo would firstly provide a 'separation  of concerns' when it comes to isolating the infrastructure components and structures from the actual code of the components. In addition, as an open-source project it will provide efficient management when it comes to a devops perspective in terms of having a 'one stop shop' when it comes to the infrastructure code. When it comes to deployment, the proposed plan which will be fully discussed in a separate CI/CD documentation will essentially at the CI stage build and package the Helm charts using the 'helm package' command, which will create build artifacts and store it for further use. Once the CI stage has completed, then the CD process will be triggered in which, the Helm chart build artifacts will be downloaded and used to upgrade the respective app/resource on the Kubernetes cluster.