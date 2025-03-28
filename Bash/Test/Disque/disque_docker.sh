#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 28 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-disque-docker.inf1430'
sysbench_repo='jseb00/sysbench'
size='10G'
time='180'
docker_number=$RANDOM
docker_name="sysbench_$docker_number"

# Start Docker image
echo "Start Docker image on $FQDN"
echo ""
ssh -t administrateur@$FQDN "docker run -d --entrypoint '' --name $docker_name $sysbench_repo tail -f /dev/null"
echo ""
echo "******************************************"

# sequential write
echo "Starting sequential write for 1 file with $FQDN"
echo ""
ssh -t administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=1 prepare"
echo ""
echo "******************************************"

# sequential read
echo "Starting sequential read for 1 file with $FQDN"
echo ""
ssh -t administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=1 --file-block-size=16M --file-test-mode=seqrd --time=$time run"
echo ""
echo "******************************************"

# Stop Docker image
echo "Stop docker image on $FQDN"
echo ""
ssh administrateur@$FQDN "docker kill $docker_name"
ssh administrateur@$FQDN 'docker system prune -a -f'
echo ""
echo "******************************************"

# Start Docker image
echo "Start Docker image on $FQDN"
echo ""
ssh -t administrateur@$FQDN "docker run -d --entrypoint '' --name $docker_name $sysbench_repo tail -f /dev/null"
echo ""
echo "******************************************"

# sequential write
echo "Starting sequential write for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=10 prepare"
echo ""
echo "******************************************"

# sequential read
echo "Starting sequential read for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=10 --file-block-size=16M --file-test-mode=seqrd --time=$time run"
echo ""
echo "******************************************"

# Random Read
echo "Starting random read for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=10 --file-test-mode=rndrd --time=$time --max-requests=0 run"
echo ""
echo "******************************************"

# Random write
echo "Starting random write for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "docker exec $docker_name sysbench fileio --file-total-size=$size --file-num=10 --file-test-mode=rndwr --time=$time --max-requests=0  run"
echo ""
echo "******************************************"

# Stop Docker image
echo "Stop docker image on $FQDN"
echo ""
ssh administrateur@$FQDN "docker kill $docker_name"
ssh administrateur@$FQDN 'docker system prune -a -f'
echo ""
echo "******************************************"
