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
