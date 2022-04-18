resource "oci_core_security_list" "k8s_security_list" {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.k8s_vcn.id
    display_name = "K8s security list"
    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol = "all"
        destination_type = "CIDR_BLOCK"
        description = "Allow all outgoing traffic"
    }
    ingress_security_rules {
        protocol = "all"
        source = var.my_public_ip
        source_type = "CIDR_BLOCK"
        description = "Allow my public IP for all protocols"
    }
    ingress_security_rules {
        protocol = 6
        source = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Allow all for SSH"
        tcp_options {
            max = 22
            min = 22
        }
    }
    ingress_security_rules {
        protocol = 6
        source = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Allow all for HTTP"
        tcp_options {
            max = 80
            min = 80
        }
    }
    ingress_security_rules {
        protocol = 6
        source = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Allow all for HTTPS"
        tcp_options {
            max = 443
            min = 443
        }
    }
    ingress_security_rules {
        protocol = 1
        source = "0.0.0.0/0"
        source_type = "CIDR_BLOCK"
        description = "Allow all for ICMP"
        icmp_options {
            type = 3
            code = 4
        }
    }
    ingress_security_rules {
        protocol = 1
        source = oci_core_subnet.k8s_subnet.cidr_block
        source_type = "CIDR_BLOCK"
        description = "Allow subnet for ICMP"
        icmp_options {
            type = 3
        }
    }
    ingress_security_rules {
        protocol = "all"
        source = oci_core_subnet.k8s_subnet.cidr_block
        source_type = "CIDR_BLOCK"
        description = "Allow subnet for all protocols"
    }
}