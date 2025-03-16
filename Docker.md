# Introduction
Ce document explique comment les images Docker sont construites pour mon projet.

# Images utilisé sans modification
Les images suivante sont disponible sur [Dockerhub](https://hub.docker.com/) directement.

- nginx
- postgresql
- python

# Images construites
Certaines applications étaient difficilement disponible alors j'ai pris la décision de la construire moi même pour mon projet. Les images sont disponible dans mon dépôt personnel [Docker](https://hub.docker.com/u/jseb00)

- iperf3
- scp
- sysbench

# Construction des images
Tous les images ont été construite dans l'environnement de Dev. Lors de son déploiement, le Git est cloné dans le /home d'administrateur. Puisque le dépôt est publique, il est possible de faire un git pull pour le mettre à jour. 

## Scripts de construction
Des scripts ont été conçus afin de faciliter la construction des images. Afin de les utiliser, il faut être dans le dossier /home/administrateur/inf1430.
<br><br>
Exemple:
```
cd /home/administrateur/inf1430
./Bash/Docker/iperf3.sh --version 1.0
```
<br>
Liste des scripts disponible:

| Conteneur | Commande|
| -------- | -------- |
|iperf3|./Bash/Docker/iperf3.sh --version x.x|
|scp|./Bash/Docker/scp.sh --version x.x|
|sysbench|./Bash/Docker/sysbench.sh --version x.x|
<br>

Tour les images sont étiquettées avec latest et la version spécifiée.

# Modification du dépôt
Une variable est déclarée au début des trois scripts afin de spécifier le dépôt. Cette variable va changer les informations aux bonnes place dans les scripts. 

# Validation des images
Afin de valider les images, voici les commandes à faire dans l'environnement de Dev. 

## iperf3
```
# Récupérer le conteneur
docker pull jseb00/iperf3:latest

# Démarrer le conteneur
docker run -p '5201:5201' -d jseb00/iperf3:latest

# Tester iperf3
iperf3 -c localhost -p 5201
```

## scp
```
# Récupérer le conteneur
docker pull jseb00/scp:latest

# Démarrer le conteneur
docker run -d -p 2222:22 jseb00/scp:latest

# Tester scp
scp -P 2222 README.md root@localhost:.
```

## sysbench
```
# Récupérer le conteneur
docker pull jseb00/sysbench:latest

# Démarrer le conteneur et recevoir la sortie
docker run --rm jseb00/sysbench:1.0 cpu run

```
