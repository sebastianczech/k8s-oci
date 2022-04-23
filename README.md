# k8s-oci

Repository contains set of prepared code to deploy free Kubernetes cluster in Oracle Cloud Infrastructure (OCI) and it's using:
* Terraform to provision infrastructure
* Ansible to configure compute instances and setup K8s cluster

For future I have a plan to extend it by adding:
* GitHub Actions for CI/CD pipeline
* Python application deployed by pipeline in created K8s cluster
* Helm charts used to deployed application
* Integration with AWS services

## Overall design

Code to deploy and configure free Kubernetes cluster in Oracle Cloud is based on idea of [Tomek's free ebook „Jak utworzyć całkowicie darmowy klaster Kubernetes w chmurze”](https://cloudowski.com/e-book-jak-utworzyc-calkowicie-darmowy-klaster-kubernetes-w-chmurze).

At first I started to prepare schema to present what is being configured in Oracle Cloud. As I like approach *everything as a code*, I prepared diagram in code using [Diagram as Code](https://diagrams.mingrammer.com/) and commands:

```
python3 -m venv venv
source venv/bin/activate
python overall_design.py
```

Overall desing consists of compute nodes, virtual network, loab balancer, route table and Internet gateway:

![Overall design](design/overall_design.png)

## Infrastructure

In order to setup infrastructure in OCI using Terraform, there were used:
* [Oracle documentation](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-simple-infrastructure/01-summary.htm)
* [Terraform documentation](https://learn.hashicorp.com/collections/terraform/oci-get-started)
* [OCI provider](https://registry.terraform.io/providers/oracle/oci/latest)

After installing ``Terraform CLI`` and ``OCI CLI``, the first step was to authenticate in Oracle Cloud:

```shell
oci session authenticate
.........
Enter the name of the profile you would like to create: k8s-oci
.........
```

Created session credentials can be checked by command:

```shell
oci iam region list --config-file /Users/seba/.oci/config --profile k8s-oci --auth security_token
```

Token can be later refreshed by command:

```shell
oci session refresh --profile k8s-oci
```

Prepared in [infrastructure configuration](infra) can be applied by commands

```shell
cd infra
terraform init # init Terraform
terraform fmt # format code
terraform validate # check if configuration is valid
terraform plan # show changes to be provisioned
terraform apply # create or update configuration
terraform apply -auto-approve # create or update configuration without asking for additional approval
terraform show # show current state of configuration
terraform state list # list current state
terraform output # display outputs value
```

All variables defined in [variables.tf](infra/variables.tf) contain default values besides 2:
- ``compartment_id``
- ``my_public_ip``

First value you can take from [Oracle Cloud web console](https://cloud.oracle.com/identity/compartments).
My public IP address you can get using command:

```
echo "my_public_ip = \"`curl -s ifconfig.co`/32\"" 2> /dev/null 1>> terraform.tfvars
```

After configuring all elements from overall design, in Terraform output you will get all details required to configure Kubernetes cluster. Moreover there will be generated automatically:
- Ansible inventory from [template](infra/inventory.tmpl)
- Ansible varialbes from [template](infra/vars.tmpl)
- scripts to connect to machines via ssh using [template](infra/ssh.tmpl)

## Configuration

Terraform is greate for infrastrcture, but for configuration I like Ansible. Using below commands you can install Ansible via pip and create role from scratch (if you want)

```
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

ansible-galaxy init conf-k8s-oracle-cloud
```

To use Ansible role and playbook prepared by me, you can directly execute command:

```
cd conf
ansible-playbook -i ../infra/inventory.ini playbook.yml
```

Playbook is going to:
- install required packages like ``Docker`` or ``microk8s``
- configure ``iptables``
- generate certificates used by ``microk8s``
- configure ``microk8s`` cluster
