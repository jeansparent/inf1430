#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 16 mars 2025

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --version) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                VERSION="$2"
                shift  
            else
                echo "Erreur : --version nécessite une valeur (ex: --version 1.0)"
                exit 1
            fi
            ;;
        --help) help=true ;;
        --) shift; break ;;
        *) echo "Option inconnue : $1"; exit 1 ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--env <valeur>] [--help]"
    echo "  --version val    Spécifie la version"
    echo "  --help         Affiche cette aide"
    exit 0
fi

docker build -t jseb00/scp:$VERSION -t jseb00/scp:latest /home/administrateur/inf1430/Docker/scp/

docker login

docker push jseb00/scp:$VERSION
docker push jseb00/scp:latest