#!/usr/bin/env bash

logdna-agent -t "provider:ibm"
logdna-agent -t "host:$(hostname -s)"
systemctl enable --now logdna-agent
systemctl start logdna-agent