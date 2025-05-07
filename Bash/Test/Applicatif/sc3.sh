#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 3 mai 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --ip) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                IP="$2"
                shift
            else
                echo "Erreur : --ip nécessite une valeur (ex: --ip)"
                exit 1
            fi
            ;;
        --url) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                URL="$2"
                shift
            else
                echo "Erreur : --url nécessite une valeur (ex: --url http://)"
                exit 1
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
    echo "  --url val    Spécifie l'url"
    echo "  --ip val    Spécifie l'IP"
    echo "  --help         Affiche cette aide"
    exit 0
fi

for i in {1..1}; do
    echo "Cleanup VM"
    ssh -P 22 administrateur@$IP "rm -rf /home/administrateur/pid*.log"
    rm -rf /home/administrateur/pid*.log

    echo "Starting pidstat"
    ssh -P 22 administrateur@$IP "nohup pidstat -u 1 > pidstat_cpu.log 2>&1 &"
    pidstat_cpu_pid=$!
    ssh -P 22 administrateur@$IP "nohup pidstat -r 1 > pidstat_mem.log 2>&1 &"
    pidstat_mem_pid=$!

    echo "Test SC3 Page: $i concurent: 10 Total: 100"
    ab -n 100 -c 10 "$URL/DB-API?records=1000&page=$i"

    echo "Stop pidstat"
    ssh -P 22 administrateur@$IP "pkill -f pistart"

    echo "Transfert pidstat file"
    scp -P 22 administrateur@$IP:pidstat* ./

    echo "========== PIDSTAT REPORT for python =========="
    cpu_values=$(grep -a "python" pidstat_cpu.log | tr -s ' ' | cut -d ' ' -f 8)
    cpu_number_value=$(echo "$cpu_values" | wc -l)
    cpu_sum=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum}')
    cpu_mean=$(echo "$cpu_sum / $cpu_number_value" | bc -l)
    cpu_max=$(echo "$cpu_values" | sort -nr | head -1)


    mem_values=$(grep -a "python" pidstat_mem.log | tr -s ' ' | cut -d ' ' -f 7)
    mem_number_value=$(echo "$mem_values" | wc -l)
    mem_sum=$(echo "$mem_values" | awk '{sum+=$1} END {print sum}')
    mem_mean=$(echo "$mem_sum / $mem_number_value" | bc -l)
    mem_max=$(echo "$mem_values" | sort -nr | head -1)

    echo "Max CPU usage for python: $cpu_max %"
    echo "Mean CPU usage for python: $cpu_mean %"
    echo "Max MEM (RSS) for python: $mem_max KB"
    echo "Mean MEM (RSS) for python: $mem_mean KB"
    echo "============================================="

    echo "Cleanup VM"
    ssh -P 22 administrateur@$IP "rm -rf /home/administrateur/pid*.log"
    rm -rf /home/administrateur/pid*.log

    echo "Starting pidstat"
    ssh -P 22 administrateur@$IP "nohup pidstat -u 1 > pidstat_cpu.log 2>&1 &"
    pidstat_cpu_pid=$!
    ssh -P 22 administrateur@$IP "nohup pidstat -r 1 > pidstat_mem.log 2>&1 &"
    pidstat_mem_pid=$!

    echo "Test SC3 Page: $i concurent: 10 Total: 5000"
    ab -n 5000 -c 10 "$URL/DB-API?records=5000&page=$i"

    echo "Stop pidstat"
    ssh -P 22 administrateur@$IP "pkill -f pistart"

    echo "Transfert pidstat file"
    scp -P 22 administrateur@$IP:pidstat* ./

    echo "Test SC3 Page: $i concurent: 10 Total: 5000"
    ab -n 5000 -c 10 "$URL/DB-API?records=5000&page=$i"

    echo "========== PIDSTAT REPORT for python =========="
    cpu_values=$(grep -a "python" pidstat_cpu.log | tr -s ' ' | cut -d ' ' -f 8)
    cpu_number_value=$(echo "$cpu_values" | wc -l)
    cpu_sum=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum}')
    cpu_mean=$(echo "$cpu_sum / $cpu_number_value" | bc -l)
    cpu_max=$(echo "$cpu_values" | sort -nr | head -1)


    mem_values=$(grep -a "python" pidstat_mem.log | tr -s ' ' | cut -d ' ' -f 7)
    mem_number_value=$(echo "$mem_values" | wc -l)
    mem_sum=$(echo "$mem_values" | awk '{sum+=$1} END {print sum}')
    mem_mean=$(echo "$mem_sum / $mem_number_value" | bc -l)
    mem_max=$(echo "$mem_values" | sort -nr | head -1)

    echo "Max CPU usage for python: $cpu_max %"
    echo "Mean CPU usage for python: $cpu_mean %"
    echo "Max MEM (RSS) for python: $mem_max KB"
    echo "Mean MEM (RSS) for python: $mem_mean KB"
    echo "============================================="
done