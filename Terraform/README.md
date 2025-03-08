# Terraform

## Introduction
Ce document présente comment utiliser Terraform dans le cadre du projet INF1430.

## Variable d'environnement pour Terraform et Azure
Cette variable permet de spécifier l'organisation Azure qui sera utilisé.

```
export TF_VAR_subscription_id='ORG ID'
```

## Connexion à Azure
Pour utiliser Terraform, il faut se connecter à Azure. Il est possible d'utiliser des variables d'environnements. Toutefois, dans le cadre de ce projet, je ne voulais pas inclure ce type d’information dans un dépôt Git public. Donc, il faut utiliser la commande az afin de faire la connexion.

### À partir de WSL
Ma configuration WSL 2 me donnait des erreurs, alors j'ai ajouté la commande --use-device-code afin de pouvoir faire la connexion.

```
az login --use-device-code --allow-no-subscriptions
az account set --subscription $TF_VAR_subscription_id
```

## Déploiement de la ressource VNET
Les commandes suivantes doivent être appelées à partir de la racine du projet inf1430.

```
terraform -chdir=Terraform/VNET init
terraform -chdir=Terraform/VNET plan -out vnet.plan
terraform -chdir=Terraform/VNET apply "vnet.plan"
```

## Suppression de la ressource VNET
La commande suivant supprime le VNET d'Azure.

```
terraform -chdir=Terraform/VNET destroy
```