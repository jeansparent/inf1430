#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

terraform -chdir=Terraform/Bastion destroy -auto-approve
terraform -chdir=Terraform/VNET destroy -auto-approve