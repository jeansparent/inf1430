#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 28 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-disque-docker.inf1430'
size='100G'
sysbench_repo='jseb00/sysbench'
docker_number=$RANDOM
docker_name="sysbench_$docker_number"

# Start Docker image
echo "Start Docker image on $FQDN"
echo ""
ssh -t administrateur@$FQDN "docker run -d --entrypoint '' --name $docker_name $sysbench_repo tail -f /dev/null"
echo ""
echo "******************************************"


for i in {1..5}; do
    # sequential write
    echo "Starting memory write #$i with $FQDN"
    echo ""
    ssh -t administrateur@$FQDN "docker exec $docker_name sysbench memory --time=60 --memory-oper=write --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    # sequential read
    echo "Starting read write #$i with $FQDN"
    echo ""
    ssh -t administrateur@$FQDN "docker exec $docker_name sysbench memory --time=60 --memory-oper=read --memory-total-size=$size run"
    echo ""
    echo "******************************************"

    sleep 60
done