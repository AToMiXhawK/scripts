#!/bin/bash
current_g=$(gsettings get org.gnome.system.proxy mode)
current_t=$(systemctl status tor.service | tail -1 | grep -c "Stopped Anonymizing Overlay Network.")
if [ $current_g = "'none'" ]
then
	zenity --width=500 --question --title="Proxy Switch" echo --text="Tor DISABLED, Do you want to turn on Proxy?"
	if [ $? = 0 ]
	then
		(
		echo "0" ; sleep 1
		echo "# Starting Tor Service" ;
		if [ $current_t = 1 ]
		then
			gksu systemctl start tor.service
			echo "10" ; sleep 1
			echo "# Waiting for Tor to start" ;
			per=15
			stat=$(systemctl status tor.service | grep -c "Bootstrapped 100%: Done")
			while [ $stat = 0 ]
			do
				echo $per ; sleep 1
				per=`expr $per + 5`
				stat=$(systemctl status tor.service | tail -1 | grep -c "Bootstrapped 100%: Done")
			done
		else
			echo "50" ; sleep 1
			echo "Tor Service already running" ; sleep 1
		fi
			
		echo "80" ; sleep 1
		echo "Changing Gnome Settings" ; sleep 1
			gsettings set org.gnome.system.proxy mode 'manual'
		echo "90" ; sleep 1
		echo "# Finishing Jobs" ; sleep 1
		echo "100" ; sleep 1
		echo "# Tor Started Successfully"
		) |
		zenity --progress --width=500 --auto-close\
		  --title="Proxy Switch" \
		  --text="Turning Tor ON..." \
		  --percentage=0

		if [ "$?" = 0 ] ; then
        		zenity --notification --width=500 \
        		  --text="Tor Started Successfully"

		else
			zenity --error --width=500 \
        		  --text="Process cancelled"
		fi
	
	else
		zenity --error --width=500 \
        	 --text="Process cancelled"
	fi
	

else
	zenity --width=500 --question --title="Proxy Switch" echo --text="Tor Enabled, What do you want to do?\n Press Yes to Restart Tor Sevice.\n Press No to Disable Tor"
	if [ $? = 0 ]	
	then
			(
			echo "0" ; sleep 1
			echo "# Restarting Tor Service" ;
				gksu systemctl restart tor.service
				echo "10" ; sleep 1
				echo "# Waiting for Tor to start" ;
				per=15
				stat=$(systemctl status tor.service | grep -c "Bootstrapped 100%: Done")
				while [ $stat = 0 ]
				do
					echo $per ; sleep 1
					per=`expr $per + 5`
					stat=$(systemctl status tor.service | tail -1 | grep -c "Bootstrapped 100%: Done")
				done
			echo "80" ; sleep 1
			echo "Changing Gnome Settings" ; sleep 1
				gsettings set org.gnome.system.proxy mode 'manual'
			echo "90" ; sleep 1
			echo "# Finishing Jobs" ; sleep 1
			echo "100" ; sleep 1
			echo "# Tor Restarted Successfully"
			) |
			zenity --progress --width=500 --auto-close\
			  --title="Proxy Switch" \
			  --text="Turning Tor ON..." \
			  --percentage=0

			if [ "$?" = 0 ] ; then
				zenity --notification --width=500 \
				  --text="Tor Restarted Successfully"

			else
				zenity --error --width=500 \
				  --text="Process cancelled"
			fi

	else
		gksu systemctl stop tor.service
		gsettings set org.gnome.system.proxy mode 'none'
		zenity --notification --title="Proxy Switch" --width=500 \
				  --text="Tor Disabled"

	fi
fi
sleep 1
firefox https://check.torproject.org/
		
