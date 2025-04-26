#!/usr/bin/env bash

# Auteur : Jean-Sébastien Parent
# Date: 26 avril 2025
# Ce script doit être exécuter à partir d'un instance bastion afin d'avoir test valide sans prendre Internet en compte.

echo "Cleanup VM"
ssh -P 22 administrateur@52.233.2.41 "rm -rf /home/administrateur/pid*.log"

echo "Pull latest jseb00/scp image"
ssh -P 22 administrateur@52.233.2.41 "docker pull jseb00/scp:latest"

echo "Start docker"
ssh -P 22 administrateur@52.233.2.41 "docker run -d -p 2222:22 jseb00/scp:latest"

echo "Starting pidstat"
ssh -P 22 administrateur@52.233.2.41 "nohup pidstat -u 1 > pidstat_cpu.log 2>&1 &"
pidstat_cpu_pid=$!
ssh -P 22 administrateur@52.233.2.41 "nohup pidstat -r 1 > pidstat_mem.log 2>&1 &"
pidstat_mem_pid=$!

echo "Transferring file"
scp -P 2222 /home/jsparent/10GBfile root@52.233.2.41:./10f.txt

echo "Transfert pidstat file"
scp -P 22 administrateur@52.233.2.41:pidstat* ./

echo "========== PIDSTAT REPORT for SSHD =========="
cpu_values=$(grep "sshd-session" pidstat_cpu.log | tr -s ' ' | cut -d ' ' -f 8)
cpu_number_value=$(echo "$cpu_values" | wc -l)
cpu_sum=$(echo "$cpu_values" | awk '{sum+=$1} END {print sum}')
cpu_mean=$(echo "$cpu_sum / $cpu_number_value" | bc -l)
cpu_max=$(echo "$cpu_values" | sort -nr | head -1)


mem_values=$(grep "sshd-session" pidstat_mem.log | tr -s ' ' | cut -d ' ' -f 7)
mem_number_value=$(echo "$mem_values" | wc -l)
mem_sum=$(echo "$mem_values" | awk '{sum+=$1} END {print sum}')
mem_mean=$(echo "$mem_sum / $mem_number_value" | bc -l)
mem_max=$(echo "$mem_values" | sort -nr | head -1)

echo "Max CPU usage for SSHD: $cpu_max %"
echo "Mean CPU usage for SSHD: $cpu_mean %"
echo "Max MEM (RSS) for SSHD: $mem_max KB"
echo "Mean MEM (RSS) for SSHD: $mem_mean KB"
echo "============================================="

echo "Clean Docker file"
ssh -P 22 administrateur@52.233.2.41 "docker system prune --all --force"

ssh -P 22 administrateur@52.233.2.41 "sudo reboot"