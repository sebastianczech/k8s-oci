# k8s-oci

Repository contains set of prepared code to deploy free Kubernetes cluster in Oracle Cloud Infrastructure (OCI) and it's using:
* Terraform to provision infrastructure
* Ansible to configure compute instances and setup K8s cluster

For future I have a plan to extend it by adding:
* GitHub Actions for CI/CD pipeline
* Python application deployed by pipeline in created K8s cluster
* Helm charts used to deployed application
* Integration with AWS services

## Overall designde

Prepare by me code to deploy and configure free Kubernetes cluster in Oracle Cloud is based on idea of [Tomek's free ebook „Jak utworzyć całkowicie darmowy klaster Kubernetes w chmurze”](https://cloudowski.com/e-book-jak-utworzyc-calkowicie-darmowy-klaster-kubernetes-w-chmurze). Based on manual actions described and explained by Tomek, I prepared code to automate whole process. 

At first I started to prepare schema to present what is being configured in Oracle Cloud. As I like approach *everything as a code*, I prepared diagram in code using [Diagram as Code](https://diagrams.mingrammer.com/) and commands:

```
python3 -m venv venv
source venv/bin/activate
python overall_design.py
```

Overall desing consists of compute nodes, networking settings like VCN, loab balancer, route table and Internet gateway:

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

Prepared in [infrastructure configuration](infra/main.tf) can be applied by commands

```shell
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform apply -auto-approve
terraform show
terraform state list
terraform output
terraform destroy
```

Error while creating instance:

```
│ Error: 404-NotAuthorizedOrNotFound, Authorization failed or requested resource not found. 
│ Suggestion: Either the resource has been deleted or service Core Instance need policy to access this resource. Policy reference: https://docs.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm
│ Documentation: https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance 
│ Request Target: POST https://iaas.eu-frankfurt-1.oraclecloud.com/20160918/instances 
│ Provider version: 4.71.0, released on 2022-04-13.  
│ Service: Core Instance 
│ Operation Name: LaunchInstance 
│ OPC request ID: 88ad55177b0228b8cd762f4496e7bd83/13144EC3AA8F8B851E92F26FBFC83F57/2A762550DCFB74C14705562A56044EA1 
│ 
│ 
│   with oci_core_instance.ubuntu_instance,
│   on main.tf line 34, in resource "oci_core_instance" "ubuntu_instance":
│   34: resource "oci_core_instance" "ubuntu_instance" {
```

Searching for root cause of the problem by checking work request:

```
oci iam work-request get --work-request-id 88ad55177b0228b8cd762f4496e7bd83/13144EC3AA8F8B851E92F26FBFC83F57/2A762550DCFB74C14705562A56044EA1
```

Then next step was changing Terraform log level into DEBUG:

```
export TF_LOG=DEBUG
terraform apply -auto-approve
```

Problem was connected with invalid shape. 
After resolving issue, warning log level was set:

```
export TF_LOG=WARN
```

My public IP address was get using command:

```
echo "my_public_ip = \"`curl -s ifconfig.co`/32\"" 2> /dev/null 1>> terraform.tfvars
```

Access instance:

```
> ssh ubuntu@130.61.28.194
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.13.0-1018-oracle aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri Apr 15 22:58:11 UTC 2022

  System load:  0.03              Processes:               152
  Usage of /:   3.0% of 44.97GB   Users logged in:         0
  Memory usage: 3%                IPv4 address for enp0s3: 172.16.0.173
  Swap usage:   0%


0 updates can be applied immediately.


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Fri Apr 15 22:57:59 2022 from 91.226.196.92
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@k8s-node1:~$ 
```

## Configuration

```
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

ansible-galaxy init conf-k8s-oracle-cloud
ansible-playbook -i ../infra/inventory.ini playbook.yml
```

## CI/CD

## Application
