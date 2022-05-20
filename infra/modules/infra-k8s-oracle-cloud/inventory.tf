resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl",
    {
      host_name  = oci_core_instance.k8s_node.*.display_name
      public_ip  = oci_core_instance.k8s_node.*.public_ip
    }
  )
  filename = "inventory.ini"
}