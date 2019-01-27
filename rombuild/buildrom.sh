#!/bin/bash
#usage:
#	Place in root directory of build folder and
#        bash buildrom.sh devicecodename gdrive/afh -q

mv build.log build_old.log
#prepare the environment

telegram-send "Build Started for $1 and file will be uploaded to $2"

make clean

telegram-send "Preparing Environment for $1"

source build/envsetup.sh
breakfast $1

export USE_CCACHE=1
ccache -M 50G
export CCACHE_COMPRESS=1
export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
export LLVM_ENABLE_THREADS=8
croot

#setup bulidnotify telegram notification
export b=1
bash buildnotify.sh 10 &

#build rom and log the build
brunch $1 |& tee build.log

export b=0	#to stop telegram buildnotify.sh

#check if the build has completed
if [ $(grep -c "build completed successfully" build.log) = 1 ]; then

	telegram-send "Build Completed. Attempting to upload"

	#get the latest zip built
	file=$(ls out/target/product/$1/*BootleggersROM*.zip | tail -n 1)

	#if gdrive send a direct link to my testing group
	if [ "$2" = "gdrive" ]; then

		id=$(gdrive upload --parent 1yaPUMFCDv8F8EvSyfwT66WH1l22tBcQM $file | grep "Uploaded" | cut -d " " -f 2)

		if [ "$id" != "" ]; then
			telegram-send "New Build is up:- https://drive.google.com/uc?export=download&id=$id"
		else
			telegram-send "HEK. Upload Failed."
		fi

	#if afh upload to afh through ftp
	elif [ "$2" = "afh" ]; then
		echo "user: "
		read user
		echo "password: "
		read password
		curl -T  $file ftp://uploads.androidfilehost.com --user $user:$password
	fi

else
	#if quiet option isn't specified, send status
	if [ "$3" != "-q" ]; then
		telegram-send "Build Failed"
	fi
fi
