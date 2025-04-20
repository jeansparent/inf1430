# Introduction
Ce document explique l'utilisation et l'importation des données dans SQL

# Engin SQL
Dans le cadre de ce projet, l'engin SQL PostgreSQL a été choisi pour sa simplicité et sa disponibilité en tant qu'image Docker. PostgreSQL est un logiciel libre, alors ce projet n'a pas besoin de licence non plus.

# Jeu de données
Le jeu de données provient des jeux de données publiques disponibles sur le site du gouvernement du Canada.

URL: https://ouvert.canada.ca/data/fr/dataset/fe1dfbb9-0fc3-42ca-b2a9-6ca4c05dbac9/resource/cb593c67-af12-4fb7-ae19-22e3a5c1cebc

Le jeu de données choisies contient 1445566 lignes de données. 

# Déploiement de postgreSQL

## APT
Voici les commandes afin de rendre disponible PostgreSQL sur Ubuntu 24.04. Par défaut, seule la version 16 est disponible dans les dépôts officiels.

```
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
```

Pour l'installation du logiciel:

```
sudo apt update
sudo apt install postgresql-17
```

## Docker
Voici la commande pour télécharger PostgreSQL 17 avec l'OS Alpine:

```
docker pull postgres:17.4-alpine3.21
```

Afin de partir le conteneur en mode détaché, voici un exemple de commande:

```
docker run -e POSTGRES_PASSWORD=Bonjour123! -p 5432:5432 -d postgres:17.4-alpine3.21
```

# Importation des données
Le script [database.sh](SQL/PostgreSQL/database.sh) permet d'importer le jeu de données [Dataset](SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv).

Le script à deux options:

| Options | Explication |
| -------- | -------- |
|--host| Adresse IP ou FQDN du serveur PostgreSQL |
|--csv| Chemin d'accès au jeu de données |

Exemple:
```
bash SQL/PostgreSQL/database.sh --host "localhost" --csv "/home/jsparent/repos/inf1430/SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv"
```
