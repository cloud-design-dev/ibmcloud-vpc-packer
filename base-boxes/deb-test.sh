#!/usr/bin/env bash 

hst=$(hostname -s)
timestamp=$(date +%m%d%Y.%H%M)
mkdir -p /opt/packer-installer
LOGFILE="/opt/packer-installer/${timestamp}-installer.log"

echo "${hst} checking in at ${timestamp} in from ${REGION}" | tee -a ${LOGFILE}

if [[ -f "/etc/issue" ]]; then
    echo "/etc/issues exists, here are the contents: " 
    cat /etc/issue | tee -a ${LOGFILE}
else 
    lsb_release -a | tee -a ${LOGFILE}
fi