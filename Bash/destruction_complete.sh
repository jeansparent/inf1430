#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

bash $PWD/Bash/Terraform/destruction_env.sh --env Dev_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Demarrage_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Demarrage_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Reseaux_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Reseaux_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Disque_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Disque_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Memoire_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Memoire_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Processeur_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Processeur_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env SCP_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env SCP_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Applicatif_Docker
bash $PWD/Bash/Terraform/destruction_env.sh --env Applicatif_VM
bash $PWD/Bash/Terraform/destruction_env.sh --env Bastion
bash $PWD/Bash/Terraform/destruction_env.sh --env VNET