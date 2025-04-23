#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 23 avril 2025

docker_repo="jseb00"
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

docker build -t $docker_repo/python-backend:$VERSION -t $docker_repo/python-backend:latest ./Python/python-backend/

docker login

docker push $docker_repo/python-backend:$VERSION
docker push $docker_repo/python-backend:latest