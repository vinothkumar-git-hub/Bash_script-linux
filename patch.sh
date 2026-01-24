#!/bin/bash

echo "Updating the System and Kenel patches:"
sudo dnf update -y

running_kernel=$(uname -r)
latest_kernel=$(rpm -q kernel-uek --last | awk '{print $1}' | head -1 | sed 's/kernel-uek-//')


if [ $latest_kernel != $running_kernel ];
then
        echo "System is Rebooting"
        sleep 3
        sudo reboot
else
        echo "Reboot not require"
fi
