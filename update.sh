#!/bin/bash

#Update apt packages
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

#Update flatpaks
flatpak update

#update snaps
sudo snap refresh

# Prompt for reboot
printf 'Would you like to reboot? (r/s/n)? '
read answer

if [[ "$answer" =~ ^[Rr] ]]; then
    echo "See you soon!"
    sudo shutdown -r now
elif [[ "$answer" =~ ^[Ss] ]]; then
    echo "See you next time!"
    sudo shutdown now
else
    echo "Update Complete"
    exit 0
fi
