#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-processeur-vm.inf1430'
size='100G'
time=120
threads=$(nproc)

for i in {1..5}; do
    # 1 cpu
    echo "Starting cpu test for 1 core #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench cpu --threads=1 --time=$time run"
    echo ""
    echo "******************************************"

    # all cpu
    echo "Starting cpu test for $threads cores #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench cpu --threads=$threads --time=$time run"
    echo ""
    echo "******************************************"

    sleep 60
done
