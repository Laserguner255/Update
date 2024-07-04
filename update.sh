#!/bin/bash

#Update apt packages
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

#Update flatpaks
if dpkg -s flatpak | grep -q 'install ok installed'; then
    flatpak update
else
    sudo apt install flatpak -y
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    if ! dpkg -s gnome-software | grep -q 'install ok installed'; then
        sudo apt install -y gnome-software-plugin-flatpak
    fi
fi

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
