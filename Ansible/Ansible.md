# Introduction
Cette section explique le fonctionnement d’Ansible et des rôles disponibles dans le dossier Ansible à la racine. 

# Structure
```
Ansible
├── Ansible
│   ├── Ansible.md
│   ├── Demarrage_Docker.yaml
│   ├── Demarrage_VM.yaml
│   ├── Disque_Docker.yaml
│   ├── Disque_VM.yaml
│   ├── Memoire_Docker.yaml
│   ├── Memoire_VM.yaml
│   ├── PostgreSQL_Docker.yaml
│   ├── PostgreSQL_VM.yaml
│   ├── Processeur_Docker.yaml
│   ├── Processeur_VM.yaml
│   ├── Reseaux_Docker.yaml
│   ├── Reseaux_VM.yaml
│   ├── SCP_Docker.yaml
│   ├── SCP_VM.yaml
│   ├── Scenario_1-3_Docker.yaml
│   ├── Scenario_1-3_VM.yaml
│   ├── Scenario_4_Docker.yaml
│   ├── Scenario_5_Docker.yaml
│   ├── Scenario_6_Docker.yaml
│   ├── Scenario_7_Docker.yaml
│   ├── bastion.yaml
│   ├── dev.yaml
│   ├── group_vars
│   │   ├── Applicatif_Docker
│   │   │   └── vars.yaml
│   │   ├── Applicatif_VM
│   │   │   └── vars.yaml
│   │   ├── all
│   │   │   └── vars.yaml
│   │   ├── bastion
│   │   │   └── vars.yaml
│   │   └── dev
│   │       └── vars.yaml
│   ├── inventory.yaml
│   └── roles
│       ├── azure-cli
│       │   └── tasks
│       │       └── main.yaml
│       ├── bastion
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── templates
│       ├── commun
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── templates
│       │       └── hosts.j2
│       ├── demarrage
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-ce
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── vars
│       │       └── main.yaml
│       ├── docker-iperf3
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-nginx
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── templates
│       │       ├── application.conf.j2
│       │       └── nginx.conf.j2
│       ├── docker-nginx-backend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   ├── templates
│       │   │   ├── application.conf.j2
│       │   │   └── nginx.conf.j2
│       │   └── vars
│       │       └── main.yaml
│       ├── docker-nginx-frontend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   ├── templates
│       │   │   ├── application.conf.j2
│       │   │   └── nginx.conf.j2
│       │   └── vars
│       │       └── main.yaml
│       ├── docker-postgresql
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-postgresql-with-data
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-python
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-python-backend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-python-frontend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-scp
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── docker-sysbench
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── file-generator
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── git-clone
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── iperf3
│       │   └── tasks
│       │       └── main.yaml
│       ├── nginx
│       │   └── tasks
│       │       └── main.yaml
│       ├── postgresql
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── handlers
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── vars
│       │       └── main.yaml
│       ├── postgresql-with-data
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   ├── tasks
│       │   │   └── main.yaml
│       │   └── vars
│       │       └── main.yaml
│       ├── python-backend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       ├── python-frontend
│       │   ├── defaults
│       │   │   └── main.yaml
│       │   └── tasks
│       │       └── main.yaml
│       └── sysbench
│           └── tasks
│               └── main.yaml
├── Bash
│   ├── Bash.md
│   ├── Configuration_WSL
│   │   └── configuration.sh
│   ├── Docker
│   │   ├── iperf3.sh
│   │   ├── python-backend.sh
│   │   ├── python-frontend.sh
│   │   ├── scp.sh
│   │   └── sysbench.sh
│   ├── Terraform
│   │   ├── deploiement_env.sh
│   │   └── destruction_env.sh
│   ├── Test
│   │   ├── Applicatif
│   │   │   ├── sc1.sh
│   │   │   ├── sc2.sh
│   │   │   ├── sc3.sh
│   │   │   └── sc4-7.sh
│   │   ├── Demarrage
│   │   │   ├── demarrage_VM.sh
│   │   │   └── demarrage_docker.sh
│   │   ├── Disque
│   │   │   ├── disque_docker.sh
│   │   │   └── disque_vm.sh
│   │   ├── Memoire
│   │   │   ├── memoire_docker.sh
│   │   │   └── memoire_vm.sh
│   │   ├── PostgreSQL
│   │   │   ├── postgresql_docker.sh
│   │   │   └── postgresql_vm.sh
│   │   ├── Processeur
│   │   │   ├── processeur_docker.sh
│   │   │   └── processeur_vm.sh
│   │   ├── Reseaux
│   │   │   ├── reseaux_docker.sh
│   │   │   └── reseaux_vm.sh
│   │   └── SCP
│   │       ├── scp_docker.sh
│   │       └── scp_vm.sh
│   ├── deploiement_bastion.sh
│   ├── deploiement_dev.sh
│   ├── deploiement_env.sh
│   ├── destruction_complete.sh
│   └── terraform_menage.sh
├── Demo
│   ├── README.md
│   ├── python3
│   │   └── api.py
│   └── terraform
│       └── main.tf
├── Docker
│   ├── Docker.md
│   ├── iperf3
│   │   └── dockerfile
│   ├── scp
│   │   ├── dockerfile
│   │   └── ssh_keys
│   │       └── authorized_keys
│   └── sysbench
│       └── dockerfile
├── Python
│   ├── Python.md
│   ├── images
│   │   └── interface.png
│   ├── python-backend
│   │   ├── dockerfile
│   │   ├── requirements.txt
│   │   ├── setup.sh
│   │   └── src
│   │       └── main.py
│   └── python-frontend
│       ├── dockerfile
│       ├── requirements.txt
│       ├── setup.sh
│       └── src
│           └── main.py
├── README.md
├── SQL
│   ├── Dataset
│   │   └── PT_priority_claim_2000001_to_4000000_2024-10-11.csv
│   ├── PostgreSQL
│   │   └── database.sh
│   └── SQL.md
└── Terraform
    ├── Applicatif_Docker
    │   └── applicatif-docker.tf
    ├── Applicatif_VM
    │   └── applicatif-vm.tf
    ├── Bastion
    │   ├── Bastion.plan
    │   ├── README.md
    │   ├── bastion.tf
    │   ├── terraform.tfstate
    │   └── terraform.tfstate.backup
    ├── Demarrage_Docker
    │   └── demarrage-docker.tf
    ├── Demarrage_VM
    │   └── demarrage-vm.tf
    ├── Dev_VM
    │   └── dev-vm.tf
    ├── Disque_Docker
    │   └── disque-docker.tf
    ├── Disque_VM
    │   └── disque-vm.tf
    ├── Gabarit_Docker
    │   └── processeur-docker.tf
    ├── Gabarit_VM
    │   └── processeur-vm.tf
    ├── Memoire_Docker
    │   └── memoire-docker.tf
    ├── Memoire_VM
    │   └── memoire-vm.tf
    ├── Processeur_Docker
    │   ├── Processeur_Docker.plan
    │   ├── processeur-docker.tf
    │   ├── terraform.tfstate
    │   └── terraform.tfstate.backup
    ├── Processeur_VM
    │   ├── Processeur_VM.plan
    │   ├── processeur-vm.tf
    │   ├── terraform.tfstate
    │   └── terraform.tfstate.backup
    ├── Reseaux_Docker
    │   └── reseaux-docker.tf
    ├── Reseaux_VM
    │   └── reseau-vm.tf
    ├── SCP_Docker
    │   └── scp-docker.tf
    ├── SCP_VM
    │   └── scp-vm.tf
    ├── Terraform.md
    └── VNET
        ├── VNET.plan
        ├── terraform.tfstate
        ├── terraform.tfstate.backup
        └── vnet.tf
```

# Inventaire
L'inventaire est construit selon le plan d'adressage disponible (ici)[Terraform.md]. 

# Group_vars
Ce dossier contient les variables pour chaque groupe d'hôtes. Le dossier all est appliqué à tous les hôtes. 

# Rôles
Ce dossier contient des groupes de tâche regroupés en rôle afin de faciliter la compréhension du texte. Lors de l'appel d'un rôle, il est important de déclarer la variable du rôle et d'y attacher la variable provenant du group_vars.<br>
Exemple:
```
    - name: Appel du role commun
      ansible.builtin.include_role:
        name: commun
      vars:
        commun_applications: "{{ applications }}"
        commun_hosts: "{{ hosts }}"
```
Cette façon de faire permet de s'assurer que la variable existe et force une double déclaration afin de ne pas avoir de surprise dans les rôles. Il est difficile de trouver des informations lorsqu’il y a plus de rôles. Ces variables doivent idéalement être déclarer vide ou avec une valeur par défaut dans le dossier défaut du rôle. 
```
commun_applications: []
common_hosts: []
```

# Utilisation des recettes (playbook)
Les playbook sont appelés en ligne de commande selon l'exemple suivant:
```
ansible-playbook -i ./Ansible/inventory.yaml ./Ansible/dev.yaml
```
Ils peuvent être appelés autant de fois que voulu puisqu'ils sont idempotents. Chaque étape a été validée de modifier ce qui est nécessaire seulement. 
