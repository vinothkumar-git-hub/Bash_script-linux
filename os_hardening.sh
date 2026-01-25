#!/bin/bash

### Linux OS Hardening ###

echo "============================"
echo "Starting Linux OS Hardening:"
echo "============================"

####################################################################################

echo "1. Set Password aging Policy"
sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   60/' /etc/login.defs
sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/'  /etc/login.defs
sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/'  /etc/login.defs

####################################################################################

echo "2. Change default file permission"

chmod 600 /etc/sudoers
chmod 600 /etc/passwd

####################################################################################

echo "3. Update Banner Info"
cat > /etc/issue.net <<EOF
########################################
#                                      #
#   P R O D U C T I O N - S E R V E R  #
#                                      #
########################################
  ****  #Authorized Users Only#  ****
########################################
EOF

####################################################################################

echo "4. Disable Root login via SSH "
sed -i 's|^#Banner.*|Banner /etc/issue.net |' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin No/' /etc/ssh/sshd_config
systemctl restart sshd

####################################################################################

echo "5. Disable SELinux Policy"
sed -i 's/^SELINUX=.*/SELINUX=enforcing/' /etc/selinux/config

####################################################################################

echo "6.Enable Firewall Service"

systemctl enable firewalld
systemctl start firewalld

####################################################################################

echo "###########################################"
echo " Successfully Completed Linux OS Hardening"
echo "###########################################"
