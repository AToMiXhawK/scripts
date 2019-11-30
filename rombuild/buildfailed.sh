#!/bin/bash
line=$(grep -n -m 1 "FAILED:" build.log | cut -f1 -d:)
line=`expr $line - 1`
tail --lines=+$line build.log >> error.log
telegram-send $(cat error.log | haste) -f error.log
exit
