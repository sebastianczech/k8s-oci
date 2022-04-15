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

resource "oci_core_vcn" "k8s_vcn" {
  dns_label      = "k8svcn"
  cidr_block     = var.vcn_cidr_block
  compartment_id = var.compartment_id
  display_name   = "K8s VCN"
}

resource "oci_core_internet_gateway" "k8s_internet_gateway" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_vcn.id
    enabled = true
    display_name = "K8s Inet Gateway"
}

# https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformbestpractices_topic-vcndefaults.htm
resource "oci_core_default_route_table" "k8s_vcn_route_table" {
    manage_default_resource_id = oci_core_vcn.k8s_vcn.default_route_table_id
    compartment_id = var.compartment_id
    display_name = "K8s default route table"
    route_rules {
        network_entity_id = oci_core_internet_gateway.k8s_internet_gateway.id
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

resource "oci_core_subnet" "k8s_subnet" {
    cidr_block = var.subnet_cidr_block
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_vcn.id
    display_name = "K8s subnet"
    dns_label = "k8ssubnet"
}

resource "oci_core_instance" "k8s_node1" {
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
        subnet_id = oci_core_subnet.k8s_subnet.id
    }
    metadata = {
        ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    }
    shape_config {
        baseline_ocpu_utilization = "BASELINE_1_1"
        memory_in_gbs = 6
        ocpus = 1
    }
    preserve_boot_volume = false
}