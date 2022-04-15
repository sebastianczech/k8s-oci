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

variable "instance_image" {
  description = "name and version of image for instance"
  type        = string
  default     = "Canonical-Ubuntu-20.04-2022.03.02-0"
}

variable "instance_shape" {
  description = "shape of instance"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
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
