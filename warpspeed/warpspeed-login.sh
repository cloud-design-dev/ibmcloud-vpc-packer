#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

SECRETS_FILE="/root/.secrets"
WARPSPEED_INSTALL_SCRIPT="/usr/local/bin/warpspeed-installer.sh"

cat <<__MESSAGE__
---------------------------------------
      Run the WarpSpeed Installer
---------------------------------------

  Run the WarpSpeed installation script, by entering:

     sudo warpspeed-installer.sh

********************************************************************************
To delete this login script: sudo rm $(readlink --canonicalize "${0}")

__MESSAGE__

if [[ -e "${SECRETS_FILE}" ]]; then
  echo "It appears that WarpSpeed has been installed"
  echo
  echo "Your initial WarpSpeed admin credentials are in ${SECRETS_FILE}"
  echo "View with: sudo cat ${SECRETS_FILE}"
  echo
  echo
else
  # The install script is usually downloaded by a cloud-init script
  # this can take a minute or two in some cases.
  while ! [[ -e "${WARPSPEED_INSTALL_SCRIPT}" ]]; do
    echo "* Waiting for WarpSpeed install script to download..."
    sleep 1
  done

  read -p "Do you want to run warpspeed-installer.sh now? (y/N): " RUN_INSTALLER
  if [[ "${RUN_INSTALLER}" =~ ^\ *[Yy] ]]; then
    ${WARPSPEED_INSTALL_SCRIPT}
  fi
fi
