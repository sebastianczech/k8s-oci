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

module "k8s_oracl_cloud" {
  source = "./modules/infra-k8s-oracle-cloud"

  compartment_id = var.compartment_id
  my_public_ip = var.my_public_ip
}
