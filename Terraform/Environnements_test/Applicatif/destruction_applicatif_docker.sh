#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 13 mars 2025

if [[ -z "$1" ]]; then
    export TF_VAR_vm_size="Standard_B1s"
else
    export TF_VAR_vm_size="$1"
fi

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

terraform -chdir=$SCRIPTPATH/Docker destroy -auto-approve
