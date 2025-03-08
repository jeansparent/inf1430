## Récupérer la liste des images Azure
Cette commande permet de récupérer la liste des images disponibles afin de les utiliser dans un fichier Terraform.
```
az vm image list --publisher Canonical --offer 0001-com-ubuntu-server-jammy --all --output table
```