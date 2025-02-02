az vm image list --publisher Canonical --offer 0001-com-ubuntu-server-jammy --all --output table

terraform init
terraform plan
terraform apply
terraform destroy