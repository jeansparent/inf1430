#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 14 mars 2025

# Scripts
find $PWD/Terraform -name ".terraform" -type d -exec rm -rf {} + 
find $PWD/Terraform -name "terraform.tfstate*" -type f -delete
find $PWD/Terraform -name "*.plan" -type f -delete
find $PWD/Terraform -name ".terraform.lock.hcl" -type f -delete
