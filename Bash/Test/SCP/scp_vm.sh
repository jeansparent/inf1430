#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 26 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

help=false

# Options du script
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --ip) 
            if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
                IP="$2"
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
    echo "  --ip val    Spécifie l'ip ou FQDN"
    echo "  --help         Affiche cette aide"
    exit 0
fi

echo "Cleanup VM"
ssh -P 22 administrateur@$IP "rm -rf /home/administrateur/pid*.log"
ssh -P 22 administrateur@$IP "rm -rf /home/administrateur/10GFile"
rm -rf /home/administrateur/pid*.log

echo "Starting pidstat"
ssh -P 22 administrateur@$IP "nohup pidstat -u 1 > pidstat_cpu.log 2>&1 &"
pidstat_cpu_pid=$!
ssh -P 22 administrateur@$IP "nohup pidstat -r 1 > pidstat_mem.log 2>&1 &"
pidstat_mem_pid=$!

echo "Transferring file"
scp -P 22 /home/administrateur/10GFile administrateur@$IP:./10f.txt

echo "Transfert pidstat file"
scp -P 22 administrateur@$IP:pidstat* ./

echo "========== PIDSTAT REPORT for SSHD =========="
cpu_values=$(grep "sshd" pidstat_cpu.log | tr -s ' ' | cut -d ' ' -f 8)
cpu_number_value=$(echo "$cpu_values" | wc -l)
cpu_sum=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum}')
cpu_mean=$(echo "$cpu_sum / $cpu_number_value" | bc -l)
cpu_max=$(echo "$cpu_values" | sort -nr | head -1)


mem_values=$(grep "sshd" pidstat_mem.log | tr -s ' ' | cut -d ' ' -f 7)
mem_number_value=$(echo "$mem_values" | wc -l)
mem_sum=$(echo "$mem_values" | awk '{sum+=$1} END {print sum}')
mem_mean=$(echo "$mem_sum / $mem_number_value" | bc -l)
mem_max=$(echo "$mem_values" | sort -nr | head -1)

echo "Max CPU usage for SSHD: $cpu_max %"
echo "Mean CPU usage for SSHD: $cpu_mean %"
echo "Max MEM (RSS) for SSHD: $mem_max KB"
echo "Mean MEM (RSS) for SSHD: $mem_mean KB"
echo "============================================="

ssh -P 22 administrateur@$IP "sudo reboot"