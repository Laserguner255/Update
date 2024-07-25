#!/bin/bash
PWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#Setup
printf 'Apt support (y/n) '
read apt

if [[ "$apt" =~ ^[Yy] ]]; then
	echo 
elif [[ "$apt" =~ ^[Nn] ]]; then
	sed -i '61,63 s/^#*/#/' -i "${PWD}"/update.sh
else
	echo "Input not understood please try again"
	exit
fi

printf 'Flatpak support (if it is not installed it will be if yes is selected) (y/n) '
read flatpak

if [[ "$flatpak" =~ ^[Yy] ]]; then
	echo 
elif [[ "$flatpak" =~ ^[Nn] ]]; then
	sed -i '66,74 s/^#*/#/' -i "${PWD}"/update.sh
else
	echo "Input not understood please try again. Your previous choices have been saved"
	exit
fi

printf 'Snap support (y/n) '
read snap

if [[ "$snap" =~ ^[Yy] ]]; then
	echo 
elif [[ "$snap" =~ ^[Nn] ]]; then
	sed -i '77,77 s/^#*/#/' -i "${PWD}"/update.sh
else
	echo "Input not understood please try again. Your previous choices have been saved"
	exit
fi

printf 'reboot/shutdown prompt (y/n) '
read rest

if [[ "$rest" =~ ^[Yy] ]]; then
	sed -i '2,51 s/^#*/#/' -i "${PWD}"/update.sh 
	trap "${PWD}"/update.sh EXIT
	exit
elif [[ "$rest" =~ ^[Nn] ]]; then
	sed -i '87,98 s/^#*/#/' -i "${PWD}"/update.sh
	sed -i '2,56 s/^#*/#/' -i "${PWD}"/update.sh
	trap "${PWD}"/update.sh EXIT
	exit
else
	echo "Input not understood please try again. Your previous choices have been saved"
	exit
fi

#sed -i '2,51 s/^#*/#/' -i "${PWD}"/update.sh

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

# Update Snaps
sudo snap refresh

# Clamav database
if dpkg -s clamav | grep -q 'install ok installed' ; then
    sudo freshclam
else
    echo ""
fi

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
fi

exit 
