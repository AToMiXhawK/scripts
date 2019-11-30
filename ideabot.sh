#!/bin/bash
export string="$(xclip -o)"
telegram-send "$(echo $string)"