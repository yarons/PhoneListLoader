#!/bin/bash

# Some of the SMS gateways are SMS controlled, there are others which have data connection, irrelevant to the case.
# In order to load a big list of phone numbers to the SMS controller we need a script that can
# break the phone list into an arrays of 10 and send them one by one to the controller.
# This script requires a Linux machine, a working GSM dongle and Gammu (http://wammu.eu/gammu/)
# both installed and configured.

# Usage: batch_loader.sh <phone_list_file>

# The phone list file should have the phone numbers formatted as one on each line (Can be changed) with no additional text.
# Please change DEST_NUM to the SMS controller phone number (the one that your GSM modem will understand).
# ADD_PREFIX is the prefix added to each and every message, in our case this is the admin password.

INPUT_FILE=$1
DEST_NUM=<Phone#>
ADD_PREFIX=<mgmt password>+
declare -a ACCUM_ARR

while read line
do
    ACCUM_ARR=("${ACCUM_ARR[@]}" "$line")
    if [ ${#ACCUM_ARR[@]} -ge 10 ]
      then
        echo ${ADD_PREFIX}${ACCUM_ARR[@]} | sudo gammu sendsms TEXT $DEST_NUM
        echo "${ADD_PREFIX}${ACCUM_ARR[@]} \| sudo gammu sendsms TEXT $DEST_NUM"
        unset ACCUM_ARR
        declare -a ACCUM_ARR
    fi
done < "$INPUT_FILE"
if [ ${#ACCUM_ARR[@]} -gt 0 ]
    then
        echo ${ADD_PREFIX}${ACCUM_ARR[@]} | sudo gammu sendsms TEXT $DEST_NUM
        echo "${ADD_PREFIX}${ACCUM_ARR[@]} \| sudo gammu sendsms TEXT $DEST_NUM"
fi
