#!/bin/bash

DB_HOST='localhost'
DB_PORT='5432'
DB_USER='postgres'
DB_PASS='Bonjour123!'
DB_NAME='patent'
CSV_FILE="/home/jsparent/repos/inf1430/SQL/Dataset/PT_priority_claim_2000001_to_4000000_2024-10-11.csv"

# Step 1: Create database if it doesn't exist
echo "Creating database if not exists..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q 1 || \
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"

# Step 2: Create the table
echo "Creating table 'patent'..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "
CREATE TABLE IF NOT EXISTS patent (
    id INT,
    NumBrevetINT TEXT,
    CodeRevendications TEXT,
    Origine TEXT,
    PaysPriorite TEXT,
    DateRevendication TEXT
);"

# Step 3: Import the CSV
echo "Importing CSV..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\copy patent FROM '$CSV_FILE' DELIMITER '|' CSV HEADER;"

echo "Done."
