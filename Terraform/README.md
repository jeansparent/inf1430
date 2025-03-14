# Introduction
L'application Terraform est utilisée afin de créer les environnements dans Azure.

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

