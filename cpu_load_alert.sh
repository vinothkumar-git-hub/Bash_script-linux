#!/bin/bash
###Start###

threshold=70
for i in `cat /admin/hostname`;
do
load=$(ssh $i uptime | awk '{ printf("%.2f\n", $8) }')
HOSTNAME=$(ssh $i hostname -I | awk '{print $1}')

if [[ $load > $threshold ]];
then
        echo "CPU load is $load Critical on $HOSTNAME" | mail -s "CPU Mail Alert" laptop@example.com,labuser@example.com
else
        echo "$HOSTNAME CPU load is normal" >> /admin/cpuload.log
fi
done

###End###
