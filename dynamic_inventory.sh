#!/bin/bash

cd /home/labadmin/script/automation

olam_host="https://10.118.128.32"
olam_pass=$(openssl enc -aes-256-cbc -d -a -in password.enc -pass pass:test)
olam_inventory="Linux_Patch"
olam_org="Default"
host_list="olam_ready"

#Removing the old file
rm -rf $host_list

#Fetching the existing host list from OLAM
olam_raw=$(awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k hosts list --all -f human | tail -n +3 | awk '{print $2}' | sort | uniq)

while IFS= read -r ip;
do
        if [[ "$ip" =~ ^10+\.[0-9]+\.[0-9]+\.[0-9] ]];
        then
                echo "$ip" >> "olam_ips_$lab_id_$(date "+%Y-%m-%d_%H_%M").csv"
        fi
done <<< "$olam_raw"

#Compare the linux_latest data to olam_latest data. if doesn't exits, add it to OLAM 
linux_latest=$(find . -type f -name "linux_ip_*.csv" -newermt "$(date +%Y-%m-%d)" | sort -nr | head -1)
olam_latest=$(find . -type f -name "olam_ips_*.csv" -newermt "$(date +%Y-%m-%d)" | sort -nr | head -1)

while IFS= read -r line;
do
        if ! grep -q "$line" "$olam_latest";
        then
                echo "$line"  >> "$host_list"
        fi
done < "$linux_latest"

#Create Inventory If not created
inventory_exists() {
  awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k inventory list --name "$olam_inventory" | grep -q "$olam_inventory"
}

if ! inventory_exists; then
    awx --conf.host "$olam_host" --conf.username "admin" --conf.password "$olam_pass" -k inventory create --name "$olam_inventory" --organization "$olam_org"
fi

#Adding host into Inventory if not available
while IFS= read -r ip;
do
        if [[ "$ip" =~ ^10+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];
        then
                awx --conf.host $olam_host --conf.username admin --conf.password $olam_pass -k host create --name "$ip" --inventory "$olam_inventory" --organization "$olam_org"
        fi
done < "$host_list"
