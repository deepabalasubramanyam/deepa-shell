#!/bin/bash
#
# This script is for training, and it changes frequently.
# Usage: ./adv_exercise6

# Get a name for the set of virtual machines.
echo Enter unique user identifier:
read "FIRSTNAME"
grep $FIRSTNAME firstnames && echo $FIRSTNAME is already in use. Try again && exit 3
echo $FIRSTNAME >> firstnames

# Copy template files to target directory.
## Make sure to check available disk space.
## Maybe provide feedback to users.
mkdir /var/lib/libvirt/images/$FIRSTNAME
echo 'Copying file(s)...'
cp /root/OVA/*/*.qcow2 /var/lib/libvirt/images/$FIRSTNAME/ && echo Image files successfully copied!
echo Press enter to move on to the next step:
read

# Create virtual networks
## Work with /etc/libvirt/qemu/networks/default as a starting point.
## Create one bridge for each virtual machine.
# Make list of existing IP addresses.
cd /etc/libvirt/qemu/network
grep 'ip address' * 2> /devl/null | awk -F \' '{ print $2 }' >> ips
# Assuming we want IPs in the 192.168 range.
COUNTER=0
while grep '192.168.$COUNTER' ips
do
  COUNTER=$(( COUNTER + 1 ))
done

# Now write the unique IP address to a variable.
IPADDRESS="192.168.$COUNTER.1"
# Now that we have a unique IP address, copy the VM file and substitute
# the old IP address with the new one.
cp default.xml $FIRSTNAME.xml

sed -i s/192\.168\.[0-9]*\.[0-9]*/$IPADDRESS/ $FIRSTNAME.xml
ln -s $FIRSTNAME.xml autostart/$FIRSTNAME.xml
systemctl restart libvirtd

# Import the VM files
## Make sure that each set of VMs matches the set of copied files.
## Also make sure to match unique network configuration.
virt-install -n server1-$FIRSTNAME --network bridge=$FIRSTNAME --disk=/var/lib/libvirt/images/$FIRSTNAME/server1_2.0_4-disk1.qcow2 --ram 1024 --vcpus 1 --connect qemu:///system --import --noautoconsole
virt-install -n server2-$FIRSTNAME --network bridge=$FIRSTNAME --disk=/var/lib/libvirt/images/$FIRSTNAME/server2_2.0_5-disk1.qcow2 --ram 1024 --vcpus 1 --connect qemu:///system --import --noautoconsole
virt-install -n labipa-$FIRSTNAME --network bridge=$FIRSTNAME --disk=/var/lib/libvirt/images/$FIRSTNAME/Labipa_2.0_3s-disk1.qcow2 --ram 1024 --vcpus 1 --connect qemu:///system --import --noautoconsole

# Verify operation.
## Make sure that the VMs are indeed available.
virsh list --all

# Send an expiration warning after 90 days.
echo mail "VMs are about to expire." root < . | at now + 90 days
