#!/bin/bash

x=`pacman -Qs bumblebee`
if [ -n "$x" ]
then 
	zenity --width=500 --question --title="Hawk Gfx Switch" echo --text="Graphics Card is cureently DISABLED, Do you want to turn it on?\nThis will disable Power Saving.\nConnect to External power source."
  	if [ $? = 0 ]
	then
		gksu "systemctl disable bumblebeed"
		gksu "pacman -R bumblebee --noconfirm"
		zenity --question --width=500 --title="Hawk Gfx Switch" echo --text="Reboot now?"
		if [ $? = 0 ]
		then	
			reboot
		else
			exit
		fi
	else
		exit
	fi
else 
	zenity --question --width=500 --title="Hawk Gfx Switch" echo --text="Graphics Card is cureently ENABLED, Do you want to turn it off?"
	if [ $? = 0 ]
	then
		gksu "pacman -U $HOME/.scripts/bumblebee/bumblebee-3.2.1-20-x86_64.pkg.tar.xz --noconfirm"
		gksu "systemctl enable bumblebeed"
		zenity --question --width=500 --title="Hawk Gfx Switch" echo --text="Reboot now?"
		if [ $? = 0 ]
		then
			reboot
		else
			exit
		fi
	else
		exit
	fi
fi
