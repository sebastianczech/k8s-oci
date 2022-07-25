locals {
  number_of_availability_domains = length(data.oci_identity_availability_domains.ads.availability_domains)
  instance_image                 = data.oci_core_images.oci_ubuntu_images.images[0].id
}

resource "oci_core_instance" "k8s_node" {
  count               = var.instance_count
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[count.index % local.number_of_availability_domains].name
  compartment_id      = var.compartment_id
  shape               = var.instance_shape
  source_details {
    source_id   = local.instance_image
    source_type = "image"
  }
  display_name = "k8s_node${count.index}"
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.k8s_subnet.id
  }
  metadata = {
    # ssh_authorized_keys = file("~/.ssh/id_rsa.pub")
    ssh_authorized_keys = var.id_rsa_pub
  }
  shape_config {
    baseline_ocpu_utilization = "BASELINE_1_1"
    memory_in_gbs             = 6
    ocpus                     = 1
  }
  preserve_boot_volume = false
}

data "oci_core_images" "oci_ubuntu_images" {
  compartment_id = var.compartment_id
  sort_by        = "TIMECREATED"
  sort_order     = "DESC"

  filter {
    name   = "operating_system"
    values = ["Canonical Ubuntu"]
  }

  filter {
    name   = "operating_system_version"
    values = ["20.04"]
  }

  filter {
    name   = "display_name"
    values = [".*aarch64.*"]
    regex  = true
  }

}