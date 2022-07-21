resource "local_file" "ansible_vars" {
  content = templatefile("${path.module}/vars.tmpl",
    {
      lb_public_ip = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.ip_addresses[0].ip_address
      subnet_cidr  = oci_core_subnet.k8s_subnet.cidr_block
    }
  )
  filename = "vars.yml"
}