#!/usr/bin/env bash 

set -e

hst=$(hostname -s)
timestamp=$(date +%m%d%Y.%H%M)
mkdir -p /tmp/packer-installer
LOGFILE="/tmp/packer-installer/${timestamp}-installer.log"

echo "${hst} checking in at ${timestamp} in from ${REGION}"

if [[ -f "/etc/issue" ]]; then
    echo "/etc/issues exists, here are the contents: " 
    cat /etc/issue | tee -a ${LOGFILE}
elif [[ -f "/etc/lsb_release" ]]; then
    cat /etc/lsb_release | tee -a ${LOGFILE}
else 
    lsb_release -a | tee -a ${LOGFILE}
fi