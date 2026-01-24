#!/bin/bash

THRESHOLD=75

####Fetching IP Address####
hostname=$(hostname -I | awk '{print $1}')

#######Print partition and disk usage######

df -h | grep -vE 'Filesystem|devtmpfs|tmpfs' | awk '{print $1 " "$5}i' | while read output;
do
        used_percentage=$(echo $output | awk '{print $2}' | sed 's/%//')
        partition=$(echo $output | awk '{print $1}')

        if [ $used_percentage -ge $THRESHOLD ];
        then
                echo "$partition is Reached $used_percentage % on IP $hostname $(date)" | mail -s "Memory Utilization is High" testuser1@example.com,testuser2@example.com
        fi
done
