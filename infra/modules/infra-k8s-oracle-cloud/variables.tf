variable "compartment_id" {
  description = "compartment ID"
  type        = string
}

variable "my_public_ip" {
  description = "my public IP address"
  type        = string
}

variable "ssh_authorized_keys" {
  description = "public SSH key"
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
  description = "OCID of image for instance"
  type        = string
  default     = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaafofmp3otdb5fh3ged2zhsepoh3e2dkaus636uee4vpt7jrgqssma"
}

variable "instance_shape" {
  description = "shape of instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_count" {
  description = "number of instances to create"
  type        = number
  default     = 4
}