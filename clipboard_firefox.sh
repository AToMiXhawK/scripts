#!/bin/bash
regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
string="$(xclip -o)"
if [[ $string =~ $regex ]]  		#check if text in clipboard is a valid URL
then 
   firefox "$(xclip -o)"
else
	firefox https://duckduckgo.com/?q="${string/\&/%26}"
fi
