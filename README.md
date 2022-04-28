# k8s-oci

## About repository

Repository contains set of prepared code to deploy free Kubernetes cluster in Oracle Cloud Infrastructure (OCI) and it's using:
* Terraform to provision infrastructure
* Ansible to configure compute instances and setup K8s cluster

Moreover there were prepared:
* Python application, which can be deployed in created K8s cluster
* GitHub Actions to automate build process and push image to Docker Hub
* Helm charts used to deploy application

For future there are plans to extend repository by adding:
* Extension to existing pipeline for application by adding:
  * Automated tests, before build in continuous integration stage
  * Continuous deployment stage after finishing build and push image to Docker Hub
* Add new GitHub Action to configure infrastructure
* Integration of existing application with AWS services (Free Tier)
* Alternative to Terraform code to configure infrastructure using Pulumi
* Alternative to Helm code to deploy application using Kustomize

## Quickstart

In order to quickly provision and configure your free Kubernetes cluster, please follow below tasks:

0. Register and activate account in [Oracle Cloud](https://cloud.oracle.com/)
1. Install prerequisites on local machine:
   1. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
   2. [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
   3. [Helm](https://helm.sh/docs/intro/install/)
   4. [OCI](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)
2. Clone repository:
   1. ``git clone https://github.com/sebastianczech/k8s-oci``
   2. ``cd k8s-oci``
3. Authenticate in Oracle Cloud:
   1. ``oci session authenticate --region eu-frankfurt-1 --profile-name k8s-oci``
4. Provision infrastructure:
   1. ``cd infra``
   2. ``terraform plan``
   3. ``terraform apply -auto-approve``
5. Configure Kubernetes:
   1. ``cd ../conf``
   2. ``ansible-playbook -i ../infra/inventory.ini playbook.yml``
6. Install application:
   1. ``cd ../app``
   2. ``helm upgrade --install --atomic --create-namespace --namespace flask-api -f flask-api/values.yaml flask-api flask-api``

In order to get mode details, please read below desing and description of infrastructure and configuration.

## Overall design

Code to deploy and configure free Kubernetes cluster in Oracle Cloud is based on idea of [Tomek's free ebook „Jak utworzyć całkowicie darmowy klaster Kubernetes w chmurze”](https://cloudowski.com/e-book-jak-utworzyc-calkowicie-darmowy-klaster-kubernetes-w-chmurze).

At first it was prepared schema to present what is being configured in Oracle Cloud. Overall desing was prepared using [Diagram as Code](https://diagrams.mingrammer.com/), which can be installed using commands:

```
cd design
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Diagram is generated as PNG using command:

```
python overall_design.py
```

Overall desing consists of compute nodes, virtual network, loab balancer, route table and Internet gateway:

![Overall design](design/overall_design.png)

## Infrastructure

In order to setup infrastructure in OCI using Terraform, you can use below documentation to find more information:
* [Oracle documentation](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-simple-infrastructure/01-summary.htm)
* [Terraform documentation](https://learn.hashicorp.com/collections/terraform/oci-get-started)
* [OCI provider](https://registry.terraform.io/providers/oracle/oci/latest)

After installing ``Terraform CLI`` and ``OCI CLI``, the first step was to authenticate in Oracle Cloud and save session in profile ``k8s-oci``:

```shell
oci session authenticate --region eu-frankfurt-1 --profile-name k8s-oci
```

Created session credentials can be checked by command:

```shell
oci iam region list --config-file /Users/seba/.oci/config --profile k8s-oci --auth security_token
```

Token can be later refreshed by command:

```shell
oci session refresh --profile k8s-oci
```

Whole infrastacture as a code was prepared in [infra](infra) directory and it was splitted into mutliple files:
* [main file with provider](infra/main.tf)
* [compute nodes](infra/compute.tf)
* [network configuration (VCN, subnet, route table and Internet gateway)](infra/network.tf)
* [load balancer](infra/load_balancer.tf)
* [security (ingress rules)](infra/security.tf)
* [generator of Ansible inventory](infra/inventory.tf)
* [generator of scripts to connect via SSH](infra/ssh.tf)
* [generator of Ansible variables](infra/vars.tf)

At first Terraform needs to initialized:

```shell
cd infra
terraform init
```

Then changes to be provisioned can be checked using:

```
terraform plan
```

All variables defined in [variables.tf](infra/variables.tf) contain default values besides 2 variables:
- ``compartment_id``
- ``my_public_ip``

First value you can take from [Oracle Cloud web console](https://cloud.oracle.com/identity/compartments).
My public IP address you can get using command:

```
echo "my_public_ip = \"`curl -s ifconfig.co`/32\"" 2> /dev/null 1>> terraform.tfvars
```

At the end whole configuration can be provisioned by command:

```
terraform apply -auto-approve
```

In order to check current state, you can use command:

```
terraform show
```

After configuring all elements from overall design, in Terraform output you will get all details required to configure Kubernetes cluster.

```
terraform output
```

Moreover there will be generated automatically files:
- ``inventory.ini`` - Ansible inventory from [template](infra/inventory.tmpl)
- ``vars.yml`` - Ansible varialbes from [template](infra/vars.tmpl)
- ``ssh_k8s_node0.sh``, ``ssh_k8s_node1.sh``, ``ssh_k8s_node2.sh``, ``ssh_k8s_node3.sh`` - scripts to connect to machines via ssh using [template](infra/ssh.tmpl)

## Configuration

Terraform is great for infrastrcture, but for configuration Ansible was used. Using below commands you can install Ansible via pip:

```
cd conf
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

General information about prepared Ansible role you can find in [role README.md](conf/conf-k8s-oracle-cloud/README.md). Role contains:
* tasks to configure:
  - [install required packages like ``Docker`` or ``microk8s``](conf/conf-k8s-oracle-cloud/tasks/install.yml)
  - [configure ``iptables``](conf/conf-k8s-oracle-cloud/tasks/iptables.yml)
  - [generate certificates used by ``microk8s``](conf/conf-k8s-oracle-cloud/tasks/microk8s_certs.yml)
  - [configure ``microk8s`` cluster](conf/conf-k8s-oracle-cloud/tasks/microk8s_cluster.yml)

To use Ansible role and prepared playbook from [conf](conf), you can execute command:

```
cd conf
ansible-playbook -i ../infra/inventory.ini playbook.yml
```

In order to access configured microk8s cluster, use command:

```
export KUBECONFIG=$KUBECONFIG:~/.kube/config:~/.kube/microk8s.conf
```

You can then check, if it's working, using command:

```
kubectl get all --all-namespaces
```

## Application

### Continuous integration

To check how cluster is performing, simple web application in Python with Flask was prepared.

It can run locally after installing required libraries:

```
cd conf
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

To start app, use below command:

```
python3 app.py
```

To check, if it's working, use command:

```
curl http://localhost:5080/

{
"CONFIG": "None",
"HOST": "Sebastian.local",
"TIME": "20:18:24"
}
```

Application can be packaged into Docker image:

```
docker build -t python-flask-api-hostname-env-time .
```

Which can also be run locally:

```
docker run -it --rm -p 127.0.0.1:5080:5080 --name python-flask-api-hostname-env-time python-flask-api-hostname-env-time
```

Finally we can push to e.g. Docker Hub:

```
docker tag python-flask-api-hostname-env-time:latest python-flask-api-hostname-env-time:1.0
docker tag python-flask-api-hostname-env-time:1.0 sebaczech/python-flask-api-hostname-env-time:1.0
docker push sebaczech/python-flask-api-hostname-env-time:1.0
```

To automate process, simple pipeline in [GitHub Action](.github/workflows/ci-app.yml) was prepared, which contains only 1 job to build and push image to Docker Hub. Moreover pipeline is building image for multiple platforms, including arm64, which is used on nodes created in Kubernets cluster in Oracle Cloud.

### Deployment

In order to simplify deployment of application into Kubernetes, tool [Helm](https://helm.sh/docs/intro/quickstart/) was used to create chart and install it on created cluster using commands:

```
cd app
helm upgrade --install --atomic \
      --create-namespace --namespace flask-api \
      -f flask-api/values.yaml \
      flask-api flask-api
```

Get the application URL by running these commands on one of the Kubernetes nodes:

```
mkdir ~/.kube
microk8s config > ~/.kube/config
export NODE_PORT=$(kubectl get --namespace flask-api -o jsonpath="{.spec.ports[0].nodePort}" services flask-api-chart)
export NODE_IP=$(kubectl get nodes --namespace flask-api -o jsonpath="{.items[0].status.addresses[0].address}")
curl http://$NODE_IP:$NODE_PORT
```

Installed application can be checked by commands:

```
helm list --namespace flask-api
helm status --namespace flask-api flask-api
```

In order to get more information what objects were created in Kubernetes, use commands:

```
kubectl get all --all-namespaces
```

Finally application can be uninstalled, if not needed:

```
helm uninstall --namespace flask-api flask-api
```

### Use app from Internet

In order to access app from Internet:
* NGINX controller was configured by [Ansible playbook](conf/conf-k8s-oracle-cloud/tasks/microk8s_ingress.yml)
* [Helm chart](app/flask-api/values.yaml) was adjusted by enabling ingress

Using that configuration, which is already in prepare Ansible and Helm configuration, you can use public IP for load balancer to access application from Internet:

```
export LB_PUBLIC_IP=`terraform output | grep lb_public_ip | awk -F\" '{print $2}'`
curl http://$LB_PUBLIC_IP
```