#!/usr/bin/env bash 

set -e

hst=$(hostname -s)
timestamp=$(date +%m%d%Y.%H%M)
mkdir -p /opt/packer-installer
LOGFILE="/opt/packer-installer/${timestamp}-installer.log"

echo "${hst} checking in at ${timestamp} in from ${REGION}" | tee -a ${LOGFILE}

if [[ -f "/etc/redhat-release" ]]; then
    echo "/etc/redhat-release exists, here are the contents: " 
    cat /etc/redhat-release | tee -a ${LOGFILE}
else 
    rpm | tee -a ${LOGFILE}
fi