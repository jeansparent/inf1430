#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 16 avril 2025

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --host) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                DB_HOST="$2"
                shift
            fi
            ;;
        --csv) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                CSV_FILE="$2"
                shift
            fi
            ;;
        --help) 
            help=true
            ;;
        --) 
            shift
            break
            ;;
        *) 
            echo "Option inconnue : $1"
            exit 1
            ;;
    esac
    shift
done

if $help; then
    echo "Usage: $0 [--ip <valeur>] [--help]"
    echo "  --host val    Spécifie l'ip ou FQDN de la BD"
    echo "  --csv val    Spécifie le chemin pour le fichier CSV"
    echo "  --help         Affiche cette aide"
    exit 0
fi

DB_PORT='5432'
DB_USER='postgres'
DB_PASS='Bonjour123!'
DB_NAME='patent'


# Step 1: Create database if it doesn't exist
echo "Creating database if not exists..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q 1 || \
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"

# Step 2: Create the table
echo "Creating table 'patent'..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
CREATE TABLE IF NOT EXISTS patent (
    \"Numéro du brevet\" INT,
    \"Numéro du brevet etranger / national\" TEXT,
    \"Code de type de revendications de priorité\" TEXT,
    \"Code du pays d'origine de revendications de priorité\" TEXT,
    \"Pays d'origine de revendications de priorité\" TEXT,
    \"Date de revendications de priorité\" TEXT
);"

# Step 3: Import the CSV
echo "Importing CSV..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\copy patent FROM '$CSV_FILE' DELIMITER '|' CSV HEADER;"

echo "Done."

