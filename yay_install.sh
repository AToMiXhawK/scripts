#!/bin/bash	

cyan='tput setaf 6'
yellow='tput setaf 3'
reset='tput sgr0'

# install yay

release=$(head /etc/os-release -n 1 | cut -d '"' -f 2)

case $release in 
	"Arch Linux"|"Antergos Linux"|"Manjaro Linux")

	if ! which yay > /dev/null; then
		echo -e "yay not installed! Install? (y/n) \c"
   		read
   		if "$REPLY" = "y"; then
      			sudo pacman -S git
			git clone https://aur.archlinux.org/yay.git
			cd yay
			makepkg -si					   	
		fi
	else
		echo -e "yay already installed!"
	fi
	;;

	*)
		echo -e "\n$($cyan)// woops. you're probably not running an $($yellow)Arch $($cyan)based distro$($reset)\n"
	;;

esac
echo -e "\n$($cyan)// All done."
