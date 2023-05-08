#!/bin/bash
echo "Installing Parallels Tools"

mkdir -p /tmp/parallels

if [ -f /home/vagrant/prl-tools-lin-arm.iso ]; then
  mount /home/vagrant/prl-tools-lin-arm.iso /tmp/parallels
elif [[ -f /home/vagrant/prl-tools-lin.iso ]]; then
  mount /home/vagrant/prl-tools-lin-arm.iso /tmp/parallels
else
  echo "Parallel Guest Tools ISO not found!"
  return 2
fi
	
/tmp/parallels/install --install-unattended-with-deps
umount /tmp/parallels

rm -rf /tmp/parallels
rm -f prl-tools-lin.iso
