resource "oci_core_default_security_list" "k8s_vcn_security_list" {
  manage_default_resource_id = oci_core_vcn.k8s_vcn.default_security_list_id
  compartment_id             = var.compartment_id
  display_name               = "K8s security list"
  dynamic "egress_security_rules" {
    for_each = var.egress_security_rules
    iterator = security_rule
    content {
      protocol         = security_rule.value["protocol"]
      destination      = security_rule.value["destination"]
      destination_type = security_rule.value["destination_type"]
      description      = security_rule.value["description"]
    }
  }
  ingress_security_rules {
    protocol    = "all"
    source      = var.my_public_ip
    source_type = "CIDR_BLOCK"
    description = "Allow my public IP for all protocols"
  }
  dynamic "ingress_security_rules" {
    for_each = {
      for k, v in var.ingress_security_rules : k => v
      if v["protocol"] == "6"
    }
    iterator = security_rule
    content {
      protocol    = security_rule.value["protocol"]
      source      = security_rule.value["source"]
      source_type = security_rule.value["source_type"]
      description = security_rule.value["description"]
      tcp_options {
        max = security_rule.value["port"]
        min = security_rule.value["port"]
      }
    }
  }
  dynamic "ingress_security_rules" {
    for_each = {
      for k, v in var.ingress_security_rules : k => v
      if v["protocol"] == "1"
    }
    iterator = security_rule
    content {
      protocol    = security_rule.value["protocol"]
      source      = security_rule.value["source"]
      source_type = security_rule.value["source_type"]
      description = security_rule.value["description"]
    }
  }
  ingress_security_rules {
    protocol    = 1
    source      = oci_core_subnet.k8s_subnet.cidr_block
    source_type = "CIDR_BLOCK"
    description = "Allow subnet for ICMP"
    icmp_options {
      type = 3
    }
  }
  ingress_security_rules {
    protocol    = "all"
    source      = oci_core_subnet.k8s_subnet.cidr_block
    source_type = "CIDR_BLOCK"
    description = "Allow subnet for all protocols"
  }
}