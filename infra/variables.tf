variable "compartment_id" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "profile_name" {
  description = "OCI profile name"
  type        = string
  default     = "k8s-oci"
}

variable "region" {
  description = "region where you have OCI tenancy"
  type        = string
  default     = "eu-frankfurt-1"
}

variable "vcn_cidr_block" {
  description = "vcn CIDR"
  type        = string
  default     = "172.16.0.0/20"
}

variable "subnet_cidr_block" {
  description = "subnet CIDR"
  type        = string
  default     = "172.16.0.0/24"
}

# https://docs.oracle.com/en-us/iaas/images/ubuntu-2004/
variable "instance_image" {
  description = "name and version of image for instance"
  type        = string
  default     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaafofmp3otdb5fh3ged2zhsepoh3e2dkaus636uee4vpt7jrgqssma"
}

variable "instance_shape" {
  description = "shape of instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_node1" {
  description = "name of 1 node"
  type        = string
  default     = "k8s_node1"
}

variable "instance_node2" {
  description = "name of 2 node"
  type        = string
  default     = "k8s_node2"
}

variable "instance_node3" {
  description = "name of 3 node"
  type        = string
  default     = "k8s_node3"
}

variable "instance_node4" {
  description = "name of 4 node"
  type        = string
  default     = "k8s_node4"
}
