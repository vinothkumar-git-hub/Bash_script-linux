#!/bin/bash
###Start###

THRESHOLD=70
for i in `cat /admin/hostname`;
do
RH_MEM_LOAD=$(ssh $i free -m | grep Mem | awk '{ printf("%.2f\n", $3/$2 * 100) }')
HOSTNAME=$(ssh $i hostname -I | awk '{print $1}')

if [[ $RH_MEM_LOAD > $THRESHOLD ]];
then
        echo "Memory Utilization is Reached $RH_MEM_LOAD % on $HOSTNAME" | mail -s "Memory Utilization is High" testuser1@example.com,testuser2@example.com
else
        echo "$HOSTNAME Memory Load is normal"  >> /admin/mem_load.csv
fi
done

###End###
