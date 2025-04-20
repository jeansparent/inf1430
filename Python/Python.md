# Introduction
Afin de tester la surcharge avec Docker, il est nécessaire de mettre en place une interface Web avec un service API. Ces deux composantes ont été développées avec Python.

# Intélligence Artificielle
Ce code a été partiellement corrigé, optimisé et débogué à l’aide d’une intelligence artificielle (ChatGPT et Gemini). Bien que des efforts aient été faits pour garantir sa fiabilité, il est recommandé de le tester soigneusement dans votre environnement avant toute mise en production.

# Python-frontend
## Explication
Le frontend permet d'afficher le contenu soit du [jeu de données](SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv) disponible dans le projet ou le contenu fourni par l'API du backend. L'interface utilise la librairie Python NiceGui puisqu'elle est simple et rapide à utiliser. 

## Variables d'environnement
| Variables | Explication |
| -------- | -------- |
|PYTHON_FRONTEND_CSV_PATH| Chemin d'accès au jeu de données |
|PYTHON_FRONTEND_RECORDS_PER_PAGE| Nombre de ligne d'afficher par défaut dans l'interface |
|PYTHON_FRONTEND_API_URL| URL de l'API Backend |

## Module Python
La liste des modules Python est disponible dans le fichier [requirements.txt](Python/python-frontend/requirements.txt).


Le fichier a été généré avec la commande suivante:
```
pip freeze > requirements.txt
```

## Déploiement manuel
Voici les commandes pour déployer le frontend manuellement:

```
cd Python/python-frontend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 src/main.py
```

## Déploiement automatisé
Un script est disponible afin de faire le déploiement automatiquement. Le script inclu les variables d'environnement.

```
cd Python/python-frontend
source setup.sh
python3 src/main.py
```

## Fonctionnement de l'interface
L'interface affiche par défaut le nombre de résultat selon la variable PYTHON_FRONTEND_RECORDS_PER_PAGE. L'interface permet de faire une recherche, d'aller au prochain résultat ou de reculer. De plus, il est possible de change le nombre de résultat entre 10, 100, 1000 et 10000.

![Interface](images/interface.png)

L'URL par défaut est http://x.x.x.x:8080. Cependant rien ne va s'afficher car il faut spécifié un chemin additionel dans l'URL. 

| Chemin | Explication |
| -------- | -------- |
|http://x.x.x.x:8080/CSV| Utilisation du fichier CSV directement dans l'interface Frontend sans communiquer avec l'API. |
|http://x.x.x.x:8080/CSV-API| Utilisation de l'API afin de lire le fichier CSV |
|http://x.x.x.x:8080/DB-API| Utilisation de l'API afin de communiquer avec le serveur PostgreSQL contenant les données du CSV|

Des options pour l'URL sont disponibles afin de plus facilement contrôler l'affichage avec la commande Apache Benchmark (ab) et curl.

| Options | Explication |
| -------- | -------- |
|records| Nombre de ligne retourné |
|page| Numéro de la page contenant les lignes. Le nombre de page est le nombre de ligne divisé par le nombre de ligne retourné |

Exemple d'URL:
```
http://192.168.18.250:8080/CSV
http://192.168.18.250:8080/CSV-API?records=10&page=12
http://192.168.18.250:8080/DB-API?records=10000&page=1
```

# Python-backend
## Explication
Le backend permet d'afficher le contenu soit du [jeu de données](SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv) disponible dans le projet ou de communiquer avec le serveur PostgreSQL. 

## Variables d'environnement
| Variables | Explication |
| -------- | -------- |
|PYTHON_BACKEND_CSV_PATH| Chemin d'accès au jeu de données |
|PYTHON_BACKEND_POSTGRES_HOST| IP ou FQDN du serveur PostgreSQL |
|PYTHON_BACKEND_POSTGRES_DB| Nom de la base de données |
|PYTHON_BACKEND_POSTGRES_USER| Nom d'usager pour la connexion |
|PYTHON_BACKEND_POSTGRES_PASSWORD| Mot de passe pour la connexion |

## Module Python
La liste des modules Python est disponible dans le fichier [requirements.txt](python-frontend/requirements.txt).

Le fichier a été généré avec la commande suivante:
```
pip freeze > requirements.txt
```

## Déploiement manuel
Voici les commandes pour déployer le frontend manuellement:

```
cd Python/python-backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python3 src/main.py
```

## Déploiement automatisé
Un script est disponible afin de faire le déploiement automatiquement. Le script inclu les variables d'environnement.

```
cd Python/python-backend
source setup.sh
python3 src/main.py
```

## Fonctionnement de l'API
Selon le chemin fourni dans l'URL de API, le backend lira un fichier CSV ou communiquera avec le serveur PostgreSQL. Dans les deux cas, l'API retourne les données en JSON avec l'interface frontend. 

| Chemin | Explication |
| -------- | -------- |
|http://x.x.x.x:5000/CSV?start=0&end=10| Retourne les lignes 1 à 10 du fichier CSV |
|http://x.x.x.x:5000/CSV?start=0&end=10000| retourne les lignes 1 à 10000 de la base de données PostgreSQL |

