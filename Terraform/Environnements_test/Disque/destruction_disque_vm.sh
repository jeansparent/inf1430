#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 9 mars 2025

SCRIPT=$(realpath "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

terraform -chdir=$SCRIPTPATH/VM destroy -auto-approve
