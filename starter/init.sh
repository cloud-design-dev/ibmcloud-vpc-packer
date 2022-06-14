#!/usr/bin/env bash 

set -e

LOGFILE="/tmp/${timestamp}-packer-installer.log"

echo -e "Hello from Packer template: ${PACKER_TEMPLATE}\n" | tee -a "$LOGFILE"

install_system_packages() {
    echo -e "[:: Updating system packages ::]"
    DEBIAN_FRONTEND=noninteractive apt-get -qqy update
    DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
    echo -e "[:: Installing system dependencies ::]"
    DEBIAN_FRONTEND=noninteractive apt-get -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install unzip tree python3-pip git curl build-essential jq wget python3-apt linux-headers-$(uname -r)
} 

install_ibm_tools() {
    curl -sL http://ibm.biz/idt-installer | bash
    python3 -m pip install softlayer
} 

install_system_packages
install_ibm_tools