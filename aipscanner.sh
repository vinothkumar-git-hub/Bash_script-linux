#/bin/bash
#Starting Date Wed Oct 16 06:57:17 EDT 2024
##Script Begin
echo -e "Create login User for Aipscanner: \c"
read -r user
egrep "^$user" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
        echo "$user user already exists!!"
 
else
        echo -e "Enter Password: \c"
        read -s password
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -p "$pass" "$user"
        usermod -s /bin/bash $user
        mkdir -p /home/$user
        chown $user:$user /home/$user
        echo "$user ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
        echo "$user user added successfully"
        sudo -u $user ssh-keygen
        ssh-copy-id -i /home/$user/.ssh/id_rsa.pub aipscanner@10.56.112.210
        echo "Please Enter to Continue"
        read
fi
read -p "Set Hostname: " hostname
hostnamectl set-hostname $hostname
echo "Copy discover.sh file from aipscanner.com"
scp aipscanner@10.56.112.210:discover.sh /home/$user/
chown $user:$user /home/$user/discover.sh
chmod +x /home/$user/discover.sh
sudo bash /home/$user/discover.sh
cat <<EOF > /home/$user/update-discover.sh
scp aipscanner@10.56.112.210:discover.sh ./discover.sh
EOF
chmod +x /home/$user/update-discover.sh
chown $user:$user /home/$user/update-discover.sh
read -p "Please Enter the Lab_ID: " labid
read -p "How many subnet range you have: " subnet
i=1
while [ $i -le $subnet ]
do
        read -p "Enter the S.no & Subnet(Ex, 1 10.x.x/24): " range
        i=`expr $i + 1`
        touch /home/$user/discover_$labid.sh
        chmod +x /home/$user/discover_$labid.sh
        echo "/home/$user/discover_$labid.sh $range" >> /home/$user/discover_$labid.sh
done
echo "" >> /home/$user/discover_$labid.sh
echo "# remove old scans" >> /home/$user/discover_$labid.sh
echo "find . -mindepth 1 -mtime +14 -iname "*.csv" -delete" >> /home/$user/discover_$labid.sh
chown $user:$user /home/$user/discover_$labid.sh
echo "0 0 * * * $user /home/$user/discover_$labid.sh" >> /etc/crontab
echo "0 1 * * * $user /home/$user/update-discover.sh " >> /etc/crontab
echo "Aipscanner Configured"
echo "***Check ssh aipscanner@10.56.112.210***"
sudo su - $user
##End