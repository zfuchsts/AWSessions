#!/bin/bash

# REQUIRED FILES
# ~/.aws/serial
# ~/.aws/credentials
# ~/.aws/config

# Useage: source ./awscli.sh [MFA Code]

#Check for session lock
lockpath=~/.aws/sessionlock
[ -f $lockpath ]
sesslock=$?
let "cdate=$(date "+%s")-43200"
echo $(date "+%s")
echo $cdate
echo $odate
echo $sesslock
if (($sesslock == 0)); then
	odate=$(head -n1 $lockpath)
	if [[ $cdate -lt $odate ]]; then
                echo "Exporting existing session"
                locked=1
	fi	
else
	locked=0
fi

serial=$(cat ~/.aws/serial)
keyid=$(grep key_id ~/.aws/credentials | awk -F \=\  '{ print $(NF) }')
accesskey=$(grep secret_access ~/.aws/credentials | awk -F \=\  '{ print $(NF) }')

# Generate session token
if [[ "$locked" -ne 1 ]]; then
	if [ -z ${1+x} ]; then
		echo "MFA Code: "
		read token
	else echo $1
		token=$1
	fi

	sts=$(aws sts get-session-token --serial-number $serial --token-code $token --profile default)
	sessiontoken=$(echo $sts | awk '{print $(NF)}')
	touch $lockpath
	echo $(date "+%s") > $lockpath
	echo $keyid >> $lockpath
	echo $accesskey >> $lockpath
	echo $sessiontoken >> $lockpath
else
	sessiontoken=$(awk 'NR==4' $lockpath)
fi

export AWS_ACCESS_KEY_ID=$keyid
export AWS_SECRET_ACCESS_KEY=$accesskey
export AWS_SESSION_TOKEN=$sessiontoken
echo "Session Token: $sessiontoken"
