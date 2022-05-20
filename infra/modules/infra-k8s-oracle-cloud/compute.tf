resource "oci_core_instance" "k8s_node" {
    count = var.instance_count
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.compartment_id
    shape = var.instance_shape
    source_details {
        source_id = var.instance_image
        source_type = "image"
    }
    display_name = "k8s_node${count.index}"
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