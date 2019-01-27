#!/bin/bash
telegram-send "Build Started"
telegram-send "Sending build percentage in intervals of $1 seconds"
sleep 10
while [ $b = 1 ]
do
	sleep $1
	mv ~/android/bootleggers_4.0/per.txt ~/android/bootleggers_4.0/per1.txt
	per1=$(head ~/android/bootleggers_4.0/per1.txt)
	per=$(tail -1 ~/android/bootleggers_4.0/build.log | cut -d " " -f 2 >~/android/bootleggers_4.0/per.txt | head ~/android/bootleggers_4.0/per.txt)
	if [ $(grep -c "%" ~/android/bootleggers_4.0/per.txt) = 1 ] && [ $per != $per1 ]; then
		telegram-send $per
	fi

	if [ $(grep -c "99%" ~/android/bootleggers_4.0/per.txt) = 1 ]; then
		telegram-send "Build almost finished, Stopping notifications"
		exit
	fi
done

telegram-send "Build finished"
exit
