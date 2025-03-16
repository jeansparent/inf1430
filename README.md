# Introduction
Ce projet propose une méthode pour calculer la surcharge de Docker, afin de répondre à l’hypothèse de mon projet de majeure en informatique. En plus du calcul de la surcharge, la notion d'automatisation a été introduite afin de s'assurer que tous les tests sont identiques sans aucune intervention humaine. 

# Infonuagique
Tous les tests seront faits dans Azure puisque j'avais droit à un crédit. L’utilisation d’un autre service infonuagique est possible, mais il faudra tout de même modifier tout le code Terrafom.
<br><br>
Deux enregistrements chez Azure seront utilisés afin de faire ce projet. La conception du projet sera faite dans un compte étudiant ayant le crédit. Les tests de surcharge seront faits dans un enregistrement "Pay as you go" car un enregistrement étudiant ne donne pas accès à tous les types d'instances. 

# Déploiement des environnements
Tous les déploiements sont faits à partir de script bash afin de les simplifier et aussi de s'assurer du bon ordonnancement. Les explications sont disponibles ici: [Bash](Bash.md)

## Déploiement d'un environnement
Le déploiement de l'environnement se fait en quelques étapes:
<br>
```
export TF_VAR_public_rsa='*** Clé RSA publique ***'

export TF_VAR_subscription_id='*** Azure Organization ID ***'

az login --use-device-code --allow-no-subscriptions

az account set --subscription $TF_VAR_subscription_id

bash ./Bash/deploiement_bastion.sh

bash ./Bash/deploiement_env.sh --env "env"
```
Voici la liste des environnements disponibles:
| Environnements | Commande|
| -------- | -------- |
|Applicatif_Docker|bash ./Bash/deploiement_env.sh --env Applicatif_Docker |
|Applicatif_VM|bash ./Bash/deploiement_env.sh --env Applicatif_VM |
|Demarrage_Docker|bash ./Bash/deploiement_env.sh --env Demarrage_Docker |
|Demarrage_VM|bash ./Bash/deploiement_env.sh --env Demarrage_VM |
|Disque_Docker|bash ./Bash/deploiement_env.sh --env Disque_Docker |
|Disque_VM|bash ./Bash/deploiement_env.sh --env Disque_VM |
|Memoire_Docker|bash ./Bash/deploiement_env.sh --env Memoire_Docker |
|Memoire_VM|bash ./Bash/deploiement_env.sh --env Memoire_VM |
|Processeur_Docker|bash ./Bash/deploiement_env.sh --env Processeur_Docker |
|Processeur_VM|bash ./Bash/deploiement_env.sh --env Processeur_VM |
|Reseaux_Docker|bash ./Bash/deploiement_env.sh --env Reseaux_Docker |
|Reseaux_VM|bash ./Bash/deploiement_env.sh --env Reseaux_VM |
|SCP_Docker|bash ./Bash/deploiement_env.sh --env SCP_Docker |
|SCP_VM|bash ./Bash/deploiement_env.sh --env SCP_VM |


# Terraform
Terraform est utilisé comme outils de déploiement de IaaS. Chaque environnement à son propre fichier afin de simplifier la gestion des tfstates. Les explications sont disponibles ici: [Terraform](Terraform.md) 
<br><br>
Cette page contient aussi les informations de toutes les instances qui seront utilisées dans le cadre de ce projet. 
