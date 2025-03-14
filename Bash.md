# Introduction
Le déploiement de ce projet est complètement automatisé avec les applications Ansible, Bash et Terraform. Ce document explique le fonctionnement du code afin de faire ces déploiements. 

# Clé RSA
*********  à faire ***********

# SSH Agent
*********  à faire ***********

# Connexion à Azure
Pour utiliser Terraform, il faut se connecter à Azure. Il est possible d'utiliser des variables d'environnements. Toutefois, dans le cadre de ce projet, je ne voulais pas inclure ce type d’information dans un dépôt Git public. Donc, il faut utiliser la commande az afin de faire la connexion.

# Scripts pour Terraform
Les scripts deploiement_env.sh et destruction_env.sh permettent de gérer la création et la destruction des environnements dans Azure en appelant Terraform. 

## deploiement_env.sh et destruction_env.sh
Ces scripts ont trois options possibles:

- --instance : cette option permet de préciser le type d'instance. <br> 
Si aucune instance n'est déclarée, Standard_B1s sera utilisé.

- --env : Cette option permet de spécifier quel environnement sera déployé. 

- --help : cette option affiche l'aide

## Scripts de déploiement complet
Les scripts à la racine de dossier Bash permettent de déployer un environnement au complet. Tous les environnements se déploient en deux étapes.

1- deploiement__bastion.sh : Déploiement du réseau et de la VM bastion. Cette VM permet de se connecter à l'environnement avec une adresse IP publique. Elle sera affichée à l'écran.

2- deploiement_*env*.sh : Déploiement d'un environnement de test spécifique.

### Utilisation des scripts
Des scripts ansible sont déclarés dans les scripts d'environnement afin de compléter la configuration des instances. La documentation pour ansible est disponible ici: [ansible](Ansible.md)

```
export TF_VAR_public_rsa='*** Clé RSA publique ***'
export TF_VAR_subscription_id='*** Azure Organization ID ***'
az login --use-device-code --allow-no-subscriptions
az account set --subscription $TF_VAR_subscription_id
bash ./Bash/deploiement_bastion.sh
bash ./Bash/Deploiement_env.sh
```

## Suppression des environnements
Il existe deux façons rapides de supprimer les environnements de façon automatisée

Un environnement à la fois:
```
bash ./Bash/Terraform/destruction_env.sh --env env
```
La liste d'environnement est disponible ici: [Terraform](Terraform.md)

Tous les environnements dans le bon ordre:
```
bash ./Bash/destruction_complete.sh
```

## Ménage des fichiers Terraform
Le script terraform_menage.sh permet de supprimer tous les fichiers Terraform générés lors des déploiements, y compris les fichiers ftstate.
```
bash ./Bash/destruction_complete.sh
```

