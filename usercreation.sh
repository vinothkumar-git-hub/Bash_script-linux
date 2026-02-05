#!/bin/bash

read -p "Enter the Username: " username

egrep -q ^$username /etc/passwd > /dev/null 2&>1

if [ $? -eq 0 ];
then
        echo "User already exists!!"
else
        echo "Creating $username"
        read -s -p "Enter the password for $username " password

        ##Create User and Provide Sudo Privilage##
        useradd -m $username
        echo "$username:$password" | chpasswd
        echo "$username ALL=(ALL)   NOPASSWD: ALL" >> /etc/sudoers
        echo
fi
