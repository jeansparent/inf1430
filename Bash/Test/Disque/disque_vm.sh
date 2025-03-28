#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 28 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-disque-vm.inf1430'
size='10G'
time='180'


# sequential write
echo "Starting sequential write for 1 file with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=1 prepare"
echo ""
echo "******************************************"

# sequential read
echo "Starting sequential read for 1 file with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=1 --file-block-size=16M --file-test-mode=seqrd --time=$time run"
echo ""
echo "******************************************"

# Delete file
echo "Files cleanup"
echo ""
ssh administrateur@$FQDN 'rm -f test_file.*'
echo ""
echo "******************************************"

# sequential write
echo "Starting sequential write for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=10 prepare"
echo ""
echo "******************************************"

# sequential read
echo "Starting sequential read for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=10 --file-block-size=16M --file-test-mode=seqrd --time=$time run"
echo ""
echo "******************************************"

# Random Read
echo "Starting random read for 10 file with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=10 --file-test-mode=rndrd --time=$time --max-requests=0 run"
echo ""
echo "******************************************"

# Random write
echo "Starting random write for 10 files with $FQDN"
echo ""
ssh administrateur@$FQDN "sysbench fileio --file-total-size=$size --file-num=10 --file-test-mode=rndwr --time=$time --max-requests=0  run"
echo ""
echo "******************************************"

# Delete file
echo "Files cleanup"
echo ""
ssh administrateur@$FQDN 'rm -f test_file.*'
echo ""
echo "******************************************"



