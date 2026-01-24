#!/bin/bash
threshold=75

hostname=$(hostname -I | awk '{print $1}')
used_mem=$(free -m | grep 'Mem:' | awk '{print $3/$2*100}' | cut -c 1-2)

if [ $used_mem -ge $threshold ];
then
        echo "Memory is Full on $hostname $(date)" | mail -s "Memory Utilization is High" testuser1@example.com,testuser2@example.com
fi
