# k8s-oci

Repository contains set of prepared code to deploy free Kubernetes cluster in Oracle Cloud Infrastructure (OCI) and it's using:
* Terraform to provision infrastructure
* Ansible to configure compute instances and setup K8s cluster
* GitHub Actions for CI/CD pipeline
* Python application deployed by pipeline in created K8s cluster
* Helm charts used to deployed application
* Integration with AWS services

## Overall design

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

## Configuration

## CI/CD

## Application
