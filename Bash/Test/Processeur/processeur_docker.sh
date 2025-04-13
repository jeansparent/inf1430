#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 28 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-processeur-docker.inf1430'
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
    # 1 cpu
    echo "Starting cpu test for 1 core #$i with $FQDN"
    echo ""
    ssh -t administrateur@$FQDN "docker exec $docker_name sysbench cpu --threads=1 --time=$time run"
    echo ""
    echo "******************************************"

    # all cpu
    echo "Starting cpu test for $threads cores #$i with $FQDN"
    echo ""
    ssh -t administrateur@$FQDN "docker exec $docker_name sysbench cpu --threads=$threads --time=$time run"
    echo ""
    echo "******************************************"

    sleep 60
done

