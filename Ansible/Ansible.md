# Introduction
Cette section explique le fonctionnement d’Ansible et des rôles disponibles dans le dossier Ansible à la racine. 

# Structure
```
Ansible
├── Ansible.md
├── Application_PostgreSQL_Docker.yaml
├── Application_PostgreSQL_VM.yaml
├── bastion.yaml
├── Demarrage_Docker.yaml
├── Demarrage_VM.yaml
├── dev.yaml
├── Disque_Docker.yaml
├── Disque_VM.yaml
├── group_vars
│   ├── all
│   │   └── vars.yaml
│   ├── bastion
│   │   └── vars.yaml
│   └── dev
│       └── vars.yaml
├── inventory.yaml
├── Memoire_Docker.yaml
├── Memoire_VM.yaml
├── Processeur_Docker.yaml
├── Processeur_VM.yaml
├── Reseaux_Docker.yaml
├── Reseaux_VM.yaml
├── roles
│   ├── azure-cli
│   │   └── tasks
│   │       └── main.yaml
│   ├── bastion
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── commun
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   └── templates
│   │       └── hosts.j2
│   ├── demarrage
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── docker-ce
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   └── vars
│   │       └── main.yaml
│   ├── docker-iperf3
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── docker-nginx
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   ├── tasks
│   │   │   └── main.yaml
│   │   └── templates
│   │       ├── application.conf.j2
│   │       └── nginx.conf.j2
│   ├── docker-postgresql
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── docker-python
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── docker-scp
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── docker-sysbench
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── git-clone
│   │   ├── defaults
│   │   │   └── main.yaml
│   │   └── tasks
│   │       └── main.yaml
│   ├── iperf3
│   │   └── tasks
│   │       └── main.yaml
│   ├── nginx
│   │   └── tasks
│   │       └── main.yaml
│   └── sysbench
│       └── tasks
│           └── main.yaml
├── SCP_Docker.yaml
└── SCP_VM.yaml

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
