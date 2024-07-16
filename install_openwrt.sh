#!/usr/bin/env bash
# Author: nlardon

function header_info {
  clear
  cat <<"EOF"
   Install OpenWRT
EOF
}

header_info
echo -e "\n Loading..."
NEXTID=$(pvesh get /cluster/nextid)

