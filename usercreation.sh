#!/bin/bash
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
fi
