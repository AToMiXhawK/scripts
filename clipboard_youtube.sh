#!/bin/bash
regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
string="$(xclip -o)"
if [[ $string =~ $regex ]]  		#check if text in clipboard is a valid URL
then 
   xdg-open https://youtube.com
else
	xdg-open https://www.youtube.com/results?search_query="${string/\&/%20}"
fi
