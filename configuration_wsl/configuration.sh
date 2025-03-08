#!/usr/bin/env bash

# ce script va configurer l'environnement local pour le projet INF 1430.
# L'environnement local est un WSL avec Ubuntu 24.04 
# Auteur : Jean-Sébastien Parent
# Date: 2 février 2025

sudo apt update -y
sudo apt upgrade -y

# Installation des packages communs
sudo apt install -y software-properties-common

# Ajout des répos
sudo add-apt-repository --yes --update ppa:ansible/ansible
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update

# Installation de ansible
sudo apt install -y ansible

# Installation de Terraform
sudo apt install -y terraform

# Installation d'Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# SSH-agent
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa