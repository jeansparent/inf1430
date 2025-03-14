# Introduction
L'application Terraform est utilisée afin de créer les environnements dans Azure.

# Déploiement des environnements
Voir les [Script Bash](Bash.md) disponible dans le dossier Bash à la racine. 

# Tableau des environnements

| Environnement    | Dépendance | Description |
| -------- | ------- |------- |
| VNET| Aucune  | Code IaaS pour l'aspect réseau du projet.    |
| Bastion  | VNET     | Code IaaS pour l'instance bastion avec une adresse IP publique pour accéder à d’autres environnements.|
| Dev_VM    | Aucune    | Code IaaS pour la dev en dehors du projet <br> Permet de construire de nouvelle fonctionnalité|
| Gabarit_Docker <br> Gabarit_VM   | VNET    | Gabarit pour ajouter de nouveaux environnements. <br> L'IP et les noms de variables et le nom de la VM doivent être modifiés. <BR> Voir les autres environnements pour voir la différence. |
| Applicatif_Docker <br> Applicatif_VM   | VNET    | Code IaaS pour les scénarios applicatifs |
| Demarrage_Docker <br> Demarrage_VM   | VNET    | Code IaaS pour les tests de démarrages |
| Disque_Docker <br> Disque_VM   | VNET    | Code IaaS pour les tests de disques |
| Memoire_Docker <br> Memoire_VM   | VNET    | Code IaaS pour les tests de mémoires |
| Processeur_Docker <br> Processeur_VM   | VNET    | Code IaaS pour les tests de processeur |
| Reseaux_Docker <br> Reseaux_VM   | VNET    | Code IaaS pour les tests réseaux |
| SCP_Docker <br> SCP_VM   | VNET    | Code IaaS pour les tests de transfert de fichier |

# Plan d'adressage
| Environnement | IP | IP Publique (oui/non)|FQDN|
| -------- | ------- |------- |------- |
|Bastion|192.168.0.10|oui|bastion.inf1430|
|Dev_VM|DHCP (192.168.160.0/24)|oui|.inf1430|
|Gabarit_Docker|192.168.0.250|non|.inf1430|
|Gabarit_VM|192.168.0.150|non|.inf1430|
|Applicatif_Docker|192.168.0.206|non|vm-applicatif-docker.inf1430|
|Applicatif_VM|192.168.0.106|non|vm-applicatif-vm.inf1430|
|Demarrage_Docker|192.168.0.200|non|vm-demarrage-docker.inf1430|
|Demarrage_VM|192.168.0.100|non|vm-demarrage-vm.inf1430|
|Disque_Docker|192.168.0.203|non|vm-disque-docker.inf1430|
|Disque_VM|192.168.0.103|non|vm-disque-vm.inf1430|
|Memoire_Docker|192.168.0.204|non|vm-memoire-docker.inf1430|
|Memoire_VM|192.168.0.104|non|vm-memoire-vm.inf1430|
|Processeur_Docker|192.168.0.202|non|vm-processeur-docker.inf1430|
|Processeur_VM|192.168.0.102|non|vm-processeur-vm.inf1430|
|Reseaux_Docker|192.168.0.201|non|vm-reseau-docker.inf1430|
|Reseaux_VM|192.168.0.101|non|vm-reseau-vm.inf1430|
|SCP_Docker|192.168.0.205|non|vm-scp-docker.inf1430|
|SCP_VM|192.168.0.105|non|vm-scp-vm.inf1430|
