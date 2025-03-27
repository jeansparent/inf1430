#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 27 mars 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

FQDN='vm-reseau-docker.inf1430'

# iperf for udp
echo "Starting udp test with $FQDN"
echo ""
iperf3 -c $FQDN -u -b 0 -n 5G -f m
echo ""
echo "******************************************"

# iperf for tcp
echo "Starting tcp test with $FQDN"
echo ""
iperf3 -c $FQDN -n 5G -b 0 -f m
echo ""
echo "******************************************"
