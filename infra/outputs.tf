output "availability_domain" {
  description = "availability domain"
  value       = module.k8s_oracl_cloud.availability_domain
}

output "vcn_state" {
  description = "the state of the VCN"
  value       = module.k8s_oracl_cloud.vcn_state
}

output "vcn_cidr" {
  description = "CIDR block of the core VCN"
  value       = module.k8s_oracl_cloud.vcn_cidr
}

output "vcn_id" {
  description = "ID of the core VCN"
  value       = module.k8s_oracl_cloud.vcn_id
}

output "subnet_state" {
  description = "the state of the subnet"
  value       = module.k8s_oracl_cloud.subnet_state
}

output "subnet_id" {
  description = "ID of the core subnet"
  value       = module.k8s_oracl_cloud.subnet_id
}

output "subnet_cidr" {
  description = "CIDR block of the core subnet"
  value       = module.k8s_oracl_cloud.subnet_cidr
}

output "compute_instances_public_ip" {
  description = "public IPs of created nodes"
  value       = module.k8s_oracl_cloud.compute_instances_public_ip
}

output "compute_instances" {
  value       = module.k8s_oracl_cloud.compute_instances
  description = "names and IPs of created instances"
}

output "lb_public_ip" {
  description = "public IPs of LB"
  value       = module.k8s_oracl_cloud.lb_public_ip
}

# output "oci_users" {
#   description = "OCI users"
#   # value       = data.oci_identity_users.oci_users.users
#   value       = {
#     name = data.oci_identity_users.oci_users.users.*.name
#     email = data.oci_identity_users.oci_users.users.*.email
#     state = data.oci_identity_users.oci_users.users.*.state
#   }
# }

# output "compute_node_images" {
#   description = "OCI compute node images"
#   # value = data.oci_core_images.oci_compute_node_images.images
#   value       = {
#     name = data.oci_core_images.oci_compute_node_images.images.*.display_name
#   }
# }
