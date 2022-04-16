from diagrams import Diagram, Cluster
from diagrams.oci.network import Vcn
from diagrams.oci.compute import VM
from diagrams.oci.network import InternetGateway, LoadBalancer, Vcn, RouteTable

with Diagram("Overall design", show=False, direction="TB"):
    with Cluster("Oracle Cloud Region"):        
        with Cluster("Networking"):
            vcn = Vcn("K8s VCN")
            rt = RouteTable("K8s default route table")
            ig = InternetGateway("K8s inet gateway")
            lb = LoadBalancer("K8s load balancer")            

        with Cluster("Compute"):
            k8s_nodes = [
                VM("k8s node 0"),
                VM("k8s node 1"),
                VM("k8s node 2"),
                VM("k8s node 3")
            ]

    ig >> vcn >> lb >> k8s_nodes
    vcn >> rt >> ig