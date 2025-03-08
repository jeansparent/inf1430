#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 8 mars 2025

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

terraform -chdir=$SCRIPTPATH/Bastion destroy -auto-approve
terraform -chdir=$SCRIPTPATH/VNET destroy -auto-approve