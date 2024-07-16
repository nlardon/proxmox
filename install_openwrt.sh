#!/usr/bin/env bash
# Author: nlardon

function header_info {
  clear
  cat <<"EOF"
   Install OpenWRT
   source : https://computingforgeeks.com/install-and-configure-openwrt-vm-on-proxmox-ve/
EOF
}

header_info
echo -e "\n Loading..."

wget https://downloads.openwrt.org/releases/23.05.3/targets/x86/64/openwrt-23.05.3-x86-64-generic-ext4-combined.img.gz
gunzip openwrt-*.img.gz

qemu-img resize -f raw openwrt-*.img 8G

VM_NAME=OpenWrt
VM_ID=$(pvesh get /cluster/nextid)
RAM=512
CORES=1
BRIDGE=vmbr0
IMAGE=./openwrt-23.05.3-x86-64-generic-ext4-combined.img

qm create --name $VM_NAME \
  $VM_ID --memory $RAM \
  --cores $CORES --cpu cputype=kvm64 \
  --net0 virtio,bridge=$BRIDGE \
  --scsihw virtio-scsi-pci --numa 1
  
STORAGE=local

qm importdisk $VM_ID $IMAGE $STORAGE

qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 $STORAGE:$VM_ID/vm-$VM_ID-disk-0.raw

qm set $VM_ID --serial0 socket --vga serial0
qm set $VM_ID --boot c --bootdisk virtio0
qm set $VM_ID --onboot 1
