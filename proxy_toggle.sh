#!/bin/bash
current_g=$(gsettings get org.gnome.system.proxy mode)
current_t=$(systemctl status tor.service | tail -1 | grep -c "Stopped Anonymizing Overlay Network.")
if [ $current_g = "'none'" ]
then
	zenity --width=500 --height=100 --question --title="Proxy Switch" echo --text="Tor DISABLED, Do you want to turn on Proxy huh?"
	if [ $? = 0 ]
	then
		killall firefox
		killall chrome
		(
		echo "0" ; sleep 1
		echo "# Starting Tor Service 0%" ;
		#if [ $current_t = 0 ]
		#then
			gksu systemctl start tor.service
			echo "5" ; sleep 1
			echo "# Waiting for Tor to start 10%" ;
			per=10
			stat=$(systemctl status tor.service | grep -c "Bootstrapped 100% (done): Done")
			while [ $stat = 0 ]
			do
				echo "# Waiting for Tor to start $per%" ;
				echo $per ; sleep 0.2
				per=`expr $per + 1`
				stat=$(systemctl status tor.service | tail -1 | grep -c "Bootstrapped 100% (done): Done")
			done
		#else
		#	echo "50" ; sleep 1
		#	echo "Tor Service already running" ; sleep 1
		#fi

		echo "80"
		echo "# Changing Gnome Settings 80%"
			gsettings set org.gnome.system.proxy mode 'manual' ; sleep 2
		echo "90"
		echo "# Finishing Jobs 90%" ; sleep 2
		echo "99"
		echo "# Tor Started Successfully 100%"; sleep 2
		echo "100"
		) |
		zenity --progress --width=500 --height=100 --auto-close\
		  --title="Proxy Switch" \
		  --text="Turning Tor ON..." \
		  --percentage=0

		if [ "$?" = 0 ] ; then
        		zenity --notification --width=500 --height=100 \
        		  --text="Tor Started Successfully"
				firefox --private-window https://check.torproject.org/

		else
			zenity --error --width=500 --height=100 \
        		  --text="Process cancelled"
		fi
	
	else
		zenity --error --width=500 --height=100 \
        	 --text="Process cancelled"
	fi
	

else
	zenity --width=500 --height=100 --question --title="Proxy Switch" echo --text="Tor Enabled, What do you want to do?\n Press Yes to Restart Tor Sevice.\n Press No to Disable Tor"
	if [ $? = 0 ]	
	then
			killall firefox
			(
			echo "0" ; sleep 1
			echo "# Restarting Tor Service 0%" ;
				gksu systemctl restart tor.service
				echo "5" ; sleep 1
				echo "# Waiting for Tor to start 10%" ;
				per=10
				stat=$(systemctl status tor.service | grep -c "Bootstrapped 100% (done): Done")
				while [ $stat = 0 ]
				do
					echo "# Waiting for Tor to restart $per%" ;
					echo $per ; sleep 0.2
					per=`expr $per + 1`
					stat=$(systemctl status tor.service | tail -1 | grep -c "Bootstrapped 100% (done): Done")
				done
			echo "80"
			echo "# Changing Gnome Settings 80%"
				gsettings set org.gnome.system.proxy mode 'manual' ; sleep 2
			echo "90"
			echo "# Finishing Jobs 90%" ; sleep 2
			echo "99"
			echo "# Tor Retarted Successfully 100%"; sleep 2
			echo "100"
			) |
			zenity --progress --width=500 --height=100 --auto-close\
			  --title="Proxy Switch" \
			  --text="Turning Tor ON..." \
			  --percentage=0

			if [ "$?" = 0 ] ; then
				zenity --notification --width=500 --height=100 \
				  --text="Tor Restarted Successfully"
				firefox --private-window https://check.torproject.org/

			else
				zenity --error --width=500 --height=100 \
				  --text="Process cancelled"
			fi

	else
		killall firefox
		gksu systemctl stop tor.service
		gsettings set org.gnome.system.proxy mode 'none'
		zenity --notification --title="Proxy Switch" --width=500 --height=100 \
				  --text="Tor Disabled"
		firefox https://check.torproject.org/
	fi
fi
