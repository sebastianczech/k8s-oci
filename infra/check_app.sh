export LB_PUBLIC_IP=`terraform output | grep lb_public_ip | awk -F\" '{print $2}'` && curl http://$LB_PUBLIC_IP
