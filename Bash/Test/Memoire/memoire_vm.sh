#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-memoire-vm.inf1430'
size='100G'
time=60


for i in {1..5}; do
    # sequential write
    echo "Starting memory write #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench memory --time=$time --memory-oper=write --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    # sequential read
    echo "Starting read read #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench memory --time=$time --memory-oper=read --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    sleep 60
done
