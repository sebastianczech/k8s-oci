variable "compartment_id" {
  description = "compartment ID"
  type        = string
}

variable "my_public_ip" {
  description = "my public IP address"
  type        = string
}

variable "id_rsa_pub" {
  description = "SSH public key"
  type        = string
}

variable "profile_name" {
  description = "OCI profile name"
  type        = string
  default     = "k8s-oci"
}

variable "region" {
  description = "OCI tenancy's region"
  type        = string
  default     = "eu-frankfurt-1"
}
