#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-memoire-vm.inf1430'
size='100G'


for i in {1..5}; do
    # sequential write
    echo "Starting memory write #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench memory --memory-oper=write --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    # sequential read
    echo "Starting read write #$i with $FQDN"
    echo ""
    ssh administrateur@$FQDN "sysbench memory --memory-oper=read --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    sleep 60
done
