#!/bin/bash
regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
string="$(xclip -o)"
if [[ $string =~ $regex ]]  		#check if text in clipboard is a valid URL
then 
   firefox "$(xclip -o)"
else
	firefox https://duckduckgo.com/?q="${string/\&/%26}"
fi

# first do install xclip (do: pacman -S xclip)	
# I saved this script in a new folder .scripts in Home
# and added keyboard shortcut in settings for the command:
# bash /home/githin/.scripts/clipboard_chrome.sh
# Now when i press this keyboard shortcut, if the text in clipboard is a valid URL,
# then it is opened in chrome, else does a google search for text in clipboard.	
