export LB_PUBLIC_IP=`terraform output | grep lb_public_ip | awk -F\" '{print $2}'` && for i in {1..20}; do curl http://$LB_PUBLIC_IP; sleep 0.5; done
