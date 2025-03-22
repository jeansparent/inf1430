#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 22 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --ip) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                IP="$2"
                shift
            fi
            ;;
        --vm) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                VM="$2"
                shift 
            fi
            ;;
        --resourcegroup)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                RG="$2"
                shift  
            fi
            ;;
        --help) 
            help=true
            ;;
        --) 
            shift
            break
            ;;
        *) 
            echo "Option inconnue : $1"
            exit 1
            ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--vm <valeur>] [--resourcegroup <valeur>] [--ip <valeur>] [--help]"
    echo "  --vm val    Spécifie la VM"
    echo "  --resourcegroup val    Spécifie le resource group"
    echo "  --ip val    Spécifie l'ip ou FQDN"
    echo "  --help         Affiche cette aide"
    exit 0
fi

# Validation si connecter à azure 
if ! az account show > /dev/null 2>&1; then
    echo "Azure is not connected, attempting login..."
    az login --use-device-code --allow-no-subscriptions
    if [ $? -eq 0 ]; then
        echo "Login successful!"
    else
        echo "Login failed, please check your credentials."
    fi
else
    echo "Azure is already connected."
fi

# Vérifier l'état de la VM
VM_STATUS=$(az vm get-instance-view --resource-group $RG --name $VM --query "instanceView.statuses[1].displayStatus" -o tsv)

if [[ "$VM_STATUS" == "VM running" ]]; then
    echo "La VM est en cours d'exécution."
    az vm stop --resource-group $RG --name $VM
else
    echo "La VM n'est pas en cours d'exécution."
fi

# Partir compteur
echo "Démarrage du compteur"
START=$(date +%s.%N)

# Démarrer la VM
echo "Démarrage de la VM"
az vm start --resource-group $RG --name $VM --no-wait

# wait nginx answer
echo "En attente du serveur HTTP ..."
while ! curl -s --head --fail http://$IP:80 > /dev/null; do
    printf "."
    sleep 0.1
done
echo "Le serveur HTTP est prêt !"

# Afficher le compteur en Milliseconde
END=$(date +%s.%N)
DURATION=$(echo "($END - $START) * 1000" | bc)
echo "Temps d'exécution : $DURATION ms"

# Arreter la VM
az vm stop --resource-group $RG --name $VM --no-wait