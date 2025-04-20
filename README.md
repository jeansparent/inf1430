# Introduction
Ce projet propose une méthode pour calculer la surcharge de Docker, afin de répondre à l’hypothèse de mon projet de majeure en informatique. En plus du calcul de la surcharge, la notion d'automatisation a été introduite afin de s'assurer que tous les tests sont identiques sans aucune intervention humaine. 

# Infonuagique
Tous les tests seront faits dans Azure puisque j'avais droit à un crédit. L’utilisation d’un autre service infonuagique est possible, mais il faudra tout de même modifier tout le code Terrafom.

Deux enregistrements chez Azure seront utilisés afin de faire ce projet. La conception du projet sera faite dans un compte étudiant ayant le crédit. Les tests de surcharge seront faits dans un enregistrement "Pay as you go" car un enregistrement étudiant ne donne pas accès à tous les types d'instances. 


# Terraform
Terraform est utilisé comme outils de déploiement de IaaS. Chaque environnement à son propre fichier afin de simplifier la gestion des tfstates. Les explications sont disponibles ici: [Terraform](Terraform/Terraform.md).

Cette page contient aussi les informations de toutes les instances qui seront utilisées dans le cadre de ce projet. 


# Ansible
La documentation pour [Ansible](Ansible/Ansible.md) explique son fonctionnement et sa structure.

# Docker
La documentation pour [Docker](Docker/Docker.md) explique comment les images sont construites et utilisées dans le cadre du projet.

# SQL
La documentation pour [SQL](SQL/SQL.md) explique l'utilisation de SQL et l'importation des données. 

# Python
La documentation pour [Python](Python/Python.md) explique le fonctionnement de python-frontend et de python-backend.

# Déploiement d'un environnement
Le déploiment d'un environnement de test se fait à l'aide de deux scripts Bash. Les deux scripts auraient peu être un seul fichier mais je trouve qu'il est mieux de les séparer afin d'avoir un meilleur contrôle selon mes limitations personnelles. Le script accepte tous les types d'instance disponible dans une région Azure cependant, il faut faire une demande d'augmentation de quota afin de pouvoir les utiliser.

| Déploiment de VNET et Bastion |
| -------- | 
|./Bash/deploiement_bastion.sh --region eastus --instance Standard_D2s_v6|

| Déploiement des environnements de test VM |
| -------- | 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Demarrage_VM| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Reseaux_VM|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Disque_VM| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Memoire_VM|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Processeur_VM| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env SCP_VM|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Applicatif_VM|

| Déploiement des environnements de test Docker |
| -------- | 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Demarrage_Docker| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Reseaux_Docker|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Disque_Docker| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Memoire_Docker|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Demarrage_Docker| 
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env SCP_Docker|
|./Bash/deploiement_env.sh --region eastus --instance Standard_D2s_v6 --env Applicatif_Docker|