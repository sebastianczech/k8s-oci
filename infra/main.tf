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

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "K8s VCN"
}

resource "oci_core_instance" "ubuntu_instance" {
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_id
    shape = var.instance_shape
    source_details {
        source_id = var.instance_image
        source_type = "image"
    }

    display_name = var.instance_node1
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_vcn.internal.id
    }
    metadata = {
        ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    }
    preserve_boot_volume = false
}