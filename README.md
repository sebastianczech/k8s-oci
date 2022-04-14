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
terraform show
terraform state list
```

## Configuration

## CI/CD

## Application
