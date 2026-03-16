#!/bin/bash

cd /home/labadmin/script/automation

olam_host="https://10.118.128.32"
olam_pass=$(openssl enc -aes-256-cbc -d -a -in password.enc -pass pass:test)
olam_inventory="Linux_Test_Server"
olam_org="Default"
host_list="olam_ready"
#template="NEW_Linux_Patch"

#Removing old file
rm -rf $host_list

scp labadmin@10.118.128.122:/home/labadmin/linux/linux_ip.csv /home/labadmin/script/automation/linux_ip_$(date "+%Y-%m-%d_%H_%M").csv

###########################################################################################################################################

olam_raw=$(awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k hosts list --all -f human | tail -n +3 | awk '{print $2}' | sort | uniq)

#Create Inventory If not created

inventory_exists() {
  awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k inventory list --name "$olam_inventory" | grep -q "$olam_inventory"
}

if ! inventory_exists; then
    awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k inventory create --name "$olam_inventory" --organization "$olam_org"
fi

##############################################################################################################################################

while IFS= read -r ip;
do
        if [[ "$ip" =~ ^10+\.[0-9]+\.[0-9]+\.[0-9] ]];
        then
                echo "$ip" >> "olam_ips_$(date "+%Y-%m-%d_%H_%M").csv"
        fi
done <<< "$olam_raw"

#Compare linux_latest data to olam_latest data, if not exits, then add it into "olam_ready"
linux_latest=$(find . -type f -name "linux_ip_*.csv" -newermt "$(date +%Y-%m-%d)" | sort -nr | head -1)
olam_latest=$(find . -type f -name "olam_ips_*.csv" -newermt "$(date +%Y-%m-%d)" | sort -nr | head -1)

while IFS= read -r line;
do
        if ! grep -q "$line" "$olam_latest";
        then
                ping -c 2 "$line" >/dev/null 2>&1
                if [ $? -eq 0 ];
                then
                echo "$line"  >> "$host_list"
                fi
        fi
done < "$linux_latest"

#Adding host into Inventory if not available

while IFS= read -r ip;
do
        if [[ "$ip" =~ ^10+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];
        then
                awx --conf.host $olam_host --conf.username admin --conf.password $olam_pass -k host create --name "$ip" --inventory "$olam_inventory" --organization "$olam_org"
        fi
done < "$host_list"
