oci session validate --profile k8s-oci || oci session authenticate --region eu-frankfurt-1 --profile-name k8s-oci
terraform get
terraform plan
terraform apply -auto-approve
