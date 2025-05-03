#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 3 mai 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --url) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                URL="$2"
                shift
            else
                echo "Erreur : --url nécessite une valeur (ex: --url http://)"
                exit 1
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
    echo "  --url val    Spécifie l'url"
    echo "  --help         Affiche cette aide"
    exit 0
fi

for i in {1..5}; do
    echo "Test SC3 concurent: 10 Total: 5000"
    ab -n 5000 -c 10 "$URL/DB-API?records=1000&page=$i"
done

