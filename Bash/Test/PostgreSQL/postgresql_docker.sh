#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 26 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

help=false
DB_HOST="127.0.0.1"
DB_PORT='5432'
DB_USER='postgres'
DB_PASS='Bonjour123!'
DB_NAME='patent'

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


echo "Cleanup VM"
ssh -P 22 administrateur@$DB_HOST "rm -rf /home/administrateur/pid*.log"
rm -rf /home/administrateur/pid*.log
ssh -P 22 administrateur@$DB_HOST "docker system prune --all --force"

echo "Pull PostgreSQL image"
ssh -P 22 administrateur@$DB_HOST "docker pull postgres:17.4"

echo "Start docker"
ssh -P 22 administrateur@$DB_HOST "docker run -d -p 5432:5432 -e POSTGRES_PASSWORD=$DB_PASS postgres:17.4"

echo "Attente de la disponibilité de PostgreSQL"
until PGPASSWORD=$DB_PASS psql -h $DB_HOST -U $DB_USER -d postgres -c '\q' 2>/dev/null; do
    echo "PostgreSQL pas encore disponible. Attente..."
    sleep 5
done

echo "Creating database if not exists..."
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';" | grep -q 1 || \
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;"


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

echo "Starting pidstat"
ssh -P 22 administrateur@$DB_HOST "nohup pidstat -u 1 > pidstat_cpu.log 2>&1 &"
pidstat_cpu_pid=$!
ssh -P 22 administrateur@$DB_HOST "nohup pidstat -r 1 > pidstat_mem.log 2>&1 &"
pidstat_mem_pid=$!

echo "Importing CSV"
time PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\copy patent FROM '$CSV_FILE' DELIMITER '|' CSV HEADER;"

echo "Transfert pidstat file"
scp -P 22 administrateur@$DB_HOST:pidstat* ./

echo "========== PIDSTAT REPORT for SSHD =========="
cpu_values=$(grep -a "postgres" pidstat_cpu.log | tr -s ' ' | cut -d ' ' -f 8)
cpu_number_value=$(echo "$cpu_values" | wc -l)
cpu_sum=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum}')
cpu_mean=$(echo "$cpu_sum / $cpu_number_value" | bc -l)
cpu_max=$(echo "$cpu_values" | sort -nr | head -1)


mem_values=$(grep -a "postgres" pidstat_mem.log | tr -s ' ' | cut -d ' ' -f 7)
mem_number_value=$(echo "$mem_values" | wc -l)
mem_sum=$(echo "$mem_values" | awk '{sum+=$1} END {print sum}')
mem_mean=$(echo "$mem_sum / $mem_number_value" | bc -l)
mem_max=$(echo "$mem_values" | sort -nr | head -1)

echo "Max CPU usage for SSHD: $cpu_max %"
echo "Mean CPU usage for SSHD: $cpu_mean %"
echo "Max MEM (RSS) for SSHD: $mem_max KB"
echo "Mean MEM (RSS) for SSHD: $mem_mean KB"
echo "============================================="

ssh -P 22 administrateur@$DB_HOST "sudo reboot"