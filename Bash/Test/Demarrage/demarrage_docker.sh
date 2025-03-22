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
    echo "Usage: $0 [--ip <valeur>] [--help]"
    echo "  --ip val    Spécifie l'ip ou FQDN"
    echo "  --help         Affiche cette aide"
    exit 0
fi

# Vérifier l'état du conteneur
ssh administrateur@$IP 'docker stop nginx'

# Partir compteur
echo "Démarrage du compteur"
START=$(date +%s.%N)

# Démarrer la VM
echo "Démarrage du conteneur"
ssh administrateur@$IP 'docker start nginx'

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
ssh administrateur@$IP 'docker stop nginx'