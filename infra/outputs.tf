output "availability_domain" {
  description = "availability domain"
  value       = data.oci_identity_availability_domains.ads.availability_domains[0].name
}

output "vcn_state" {
  description = "The state of the VCN"
  value       = oci_core_vcn.k8s_vcn.state
}

output "vcn_cidr" {
  description = "CIDR block of the core VCN"
  value       = oci_core_vcn.k8s_vcn.cidr_block
}

output "vcn_id" {
  description = "ID of the core VCN"
  value       = oci_core_vcn.k8s_vcn.id
}

output "subnet_state" {
  description = "The state of the subnet"
  value       = oci_core_subnet.k8s_subnet.state
}

output "subnet_id" {
  description = "ID of the core subnet"
  value       = oci_core_subnet.k8s_subnet.id
}

output "subnet_cidr" {
  description = "CIDR block of the core subnet"
  value       = oci_core_subnet.k8s_subnet.cidr_block
}

output "public-ip-for-compute-instance1" {
  value = oci_core_instance.k8s_node1.public_ip
}