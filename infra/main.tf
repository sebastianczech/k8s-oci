terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
    }
  }
}

provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = var.profile_name
}

# data "oci_identity_users" "oci_users" {
#     compartment_id = var.compartment_id
# }

# data "oci_core_images" "oci_compute_node_images" {
#     compartment_id = var.compartment_id
# }

module "k8s_oracl_cloud" {
  source = "./modules/infra-k8s-oracle-cloud"

  compartment_id = var.compartment_id
  my_public_ip = var.my_public_ip
}
