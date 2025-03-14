# Clé RSA
*********  à faire ***********

# SSH Agent
*********  à faire ***********

# Variable d'environnement pour Terraform et Azure
Cette variable permet de spécifier l'organisation Azure qui sera utilisé.

```
export TF_VAR_public_rsa='Clé RSA publique'
export TF_VAR_subscription_id='ORG ID'
```

# Connexion à Azure
Pour utiliser Terraform, il faut se connecter à Azure. Il est possible d'utiliser des variables d'environnements. Toutefois, dans le cadre de ce projet, je ne voulais pas inclure ce type d’information dans un dépôt Git public. Donc, il faut utiliser la commande az afin de faire la connexion.

# À partir de WSL
Ma configuration WSL 2 me donnait des erreurs, alors j'ai ajouté la commande --use-device-code afin de pouvoir faire la connexion.

**** à revoir ***

```
az login --use-device-code --allow-no-subscriptions
az account set --subscription $TF_VAR_subscription_id
```