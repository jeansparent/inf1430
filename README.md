# Terraform

## Introduction
Ce document présente comment utiliser Terraform dans le cadre du projet INF1430.

## Clé RSA
*********  à faire ***********

## SSH Agent
*********  à faire ***********

## Variable d'environnement pour Terraform et Azure
Cette variable permet de spécifier l'organisation Azure qui sera utilisé.

```
export TF_VAR_public_rsa='Clé RSA publique'
export TF_VAR_subscription_id='ORG ID'
```
## Lister les types d'instance disponible
Cette commmande permet de voir les types d'instance disponible dans Canada Central.

```
az vm list-sizes --location canadacentral --query "[?starts_with(name, 'Standard_D')]" --output table
```

## Connexion à Azure
Pour utiliser Terraform, il faut se connecter à Azure. Il est possible d'utiliser des variables d'environnements. Toutefois, dans le cadre de ce projet, je ne voulais pas inclure ce type d’information dans un dépôt Git public. Donc, il faut utiliser la commande az afin de faire la connexion.

### À partir de WSL
Ma configuration WSL 2 me donnait des erreurs, alors j'ai ajouté la commande --use-device-code afin de pouvoir faire la connexion.

**** à revoir ***

```
az login --use-device-code --allow-no-subscriptions
az account set --subscription $TF_VAR_subscription_id
```

## Déploiement de l'environnement de base
Les commandes suivantes doivent être appelées à partir de la racine du projet inf1430.

Création de l'environnement:
```
terraform -chdir=Terraform/VNET init
terraform -chdir=Terraform/VNET plan -out vnet.plan
terraform -chdir=Terraform/VNET apply "vnet.plan"

terraform -chdir=Terraform/Bastion init
terraform -chdir=Terraform/Bastion plan -out bastion.plan
terraform -chdir=Terraform/Bastion apply "bastion.plan"
```

Suppression de l'environnement:
```
terraform -chdir=Terraform/Bastion destroy -auto-approve
terraform -chdir=Terraform/VNET destroy -auto-approve
```

## Environnement de test
Un script Terraform est disponible pour créer un environnement de test dans Azure. Cette environnement utilise une autre plage d'adresse IP pour ne pas rentrer en conflit avec le projet. 

Création de l'environnement
```
terraform -chdir=Terraform/Test-VM init
terraform -chdir=Terraform/Test-VM plan -out test-vm.plan
terraform -chdir=Terraform/Test-VM apply "test-vm.plan"
```

Suppression de l'environnement: 
```
terraform -chdir=Terraform/Test-VM destroy -auto-approve
```

