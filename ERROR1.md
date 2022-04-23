# Error 1 - computer node invalid shape 

While creating instance I have an error like below:

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

I've started for searching for root cause of the problem by checking work request:

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