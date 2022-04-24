resource "oci_network_load_balancer_backend" "k8s_backend" {
    count = var.instance_count
    backend_set_name = oci_network_load_balancer_backend_set.k8s_backend_set.name
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    port = 16443
    ip_address = oci_core_instance.k8s_node[count.index].private_ip
    name = oci_core_instance.k8s_node[count.index].display_name
}

resource "oci_network_load_balancer_backend_set" "k8s_backend_set" {
    health_checker {
        protocol = "HTTPS"
        interval_in_millis = 10000
        port = 16443
        retries = 3
        return_code = 401
        timeout_in_millis = 3000
        url_path = "/"
    }
    name = "K8s bucket set"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    policy = "FIVE_TUPLE"
}

resource "oci_network_load_balancer_listener" "k8s_listener" {
    default_backend_set_name = oci_network_load_balancer_backend_set.k8s_backend_set.name
    name = "K8s API listener"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    port = 16443
    protocol = "TCP"
}

resource "oci_network_load_balancer_backend" "nginx_http_backend" {
    count = var.instance_count
    backend_set_name = oci_network_load_balancer_backend_set.nginx_http_backend_set.name
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    port = 80
    ip_address = oci_core_instance.k8s_node[count.index].private_ip
    name = oci_core_instance.k8s_node[count.index].display_name
}

resource "oci_network_load_balancer_backend_set" "nginx_http_backend_set" {
    health_checker {
        protocol = "HTTPS"
        interval_in_millis = 10000
        port = 80
        retries = 3
        return_code = 200
        timeout_in_millis = 3000
        url_path = "/"
    }
    name = "NGINX HTTP bucket set"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    policy = "FIVE_TUPLE"
}

resource "oci_network_load_balancer_listener" "nginx_http_listener" {
    default_backend_set_name = oci_network_load_balancer_backend_set.nginx_http_backend_set.name
    name = "NGINX HTTP listener"
    network_load_balancer_id = oci_network_load_balancer_network_load_balancer.k8s_network_load_balancer.id
    port = 80
    protocol = "TCP"
}

resource "oci_network_load_balancer_network_load_balancer" "k8s_network_load_balancer" {
    compartment_id = var.compartment_id
    display_name = "K8s network load balancer"
    subnet_id = oci_core_subnet.k8s_subnet.id
    is_private = false
}