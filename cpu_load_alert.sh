#!/bin/bash
LOAD=70.00
HOSTNAME=`hostname`
CPU_LOAD=`sar -P ALL 1 2 |grep 'Average.*all' |awk -F" " '{print 100.0 -$NF}'`
if [[ $CPU_LOAD > $LOAD ]];
then
         echo "CPU Load is Critical $CPU_LOAD on $HOSTNAME"|mail -s "cpu-alert" user1@example.com, user2@example.com
else
        echo "`date "+%F %H:%M:%S"` OK - $CPU_LOAD on $HOSTNAME" >> /home/cpu-load
fi
