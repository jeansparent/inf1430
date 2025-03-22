#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

ENVIRONNEMENT=""
REGION=""
SIZE=""
help=false

# Options du script
# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --env) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                ENVIRONNEMENT="$2"
                shift  
            else
                echo "Erreur : --env nécessite une valeur (ex: --env dev)"
                exit 1
            fi
            ;;
        --instance)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                SIZE="$2"
                shift  
            fi
            ;;
        --region)
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                REGION="$2"
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
    echo "Usage: $0 [--env <valeur>] [--instance <valeur>] [--region <valeur>] [--help]"
    echo "  --env val    Spécifie l'environnement"
    echo "  --instance val    Spécifie l'instance"
    echo "  --region val    Spécifie la région (ex: eastus)"
    echo "  --help         Affiche cette aide"
    exit 0
fi

# Vérifier si la région est spécifiée
if [[ -z "$REGION" ]]; then
    echo "Erreur : --region est requis."
    exit 1
fi


# Script
export ANSIBLE_HOST_KEY_CHECKING=False
bash $PWD/Bash/Terraform/deploiement_env.sh --env $ENVIRONNEMENT --region $REGION --instance $SIZE
internal_ip=$(terraform -chdir="$PWD/Terraform/$ENVIRONNEMENT" output -raw private_ip)
external_ip=$(terraform -chdir="$PWD/Terraform/Bastion" output -raw public_ip)

echo "Attente de la disponibilité de SSH"
while ! ssh -o StrictHostKeyChecking=no -o ProxyCommand="ssh -W %h:%p administrateur@$external_ip" \
         -o ConnectTimeout=5 administrateur@$internal_ip exit 2>/dev/null; do
    echo "SSH pas encore disponible. Attente..."
    sleep 5
done


ansible-playbook -i $PWD/Ansible/inventory.yaml $PWD/Ansible/$ENVIRONNEMENT.yaml  --ssh-common-args="-o StrictHostKeyChecking=no -o ProxyJump=administrateur@$external_ip"
