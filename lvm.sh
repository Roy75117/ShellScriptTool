#!/bin/bash
#Simple Script for lvm
#2016/8/10 Roy

if [ "$1" == "-h" ] ; then
    echo "Usage: `basename $0` /dev/sdb /dev/sdc ... /dev/sdx"
    echo "Note only support 8GB for each USB so far"
    exit 0
fi

declare -i count=0
umount /mnt/stuff
apt-get install -y lvm2
for var in "$@"
do
	#Clean out USB partition and creat linux lvm partition
	(echo o; echo n; echo p; echo 1; echo; echo; echo t; echo 8e; echo w) | sudo fdisk "$var"
	
	if [ $count == 0 ]; then
 		# If first USB device, create virtual USB and add first USB device to virtual drive
		vgcreate vgpool "$var"1
		if [ ! -d "/dev/vgpool" ]; then
			lvcreate -L 7G -n lvstuff vgpool
		fi
	else
		# Since second USB device just add to virtual drive and extend size 
		vgextend vgpool "$var"1
		lvextend -L+7G /dev/vgpool/lvstuff
	fi
	((count += 1)) 
done

if [ ! -d "/mnt/stuff" ]; then
	mkdir /mnt/stuff
fi
	# formate virtual drive and mount on /mnt/stuff
	mkfs -t ext3 /dev/vgpool/lvstuff
	mount -t ext3 /dev/vgpool/lvstuff /mnt/stuff && echo "/dev/vgpool/lvstuff is successfully mounted on /mnt/stuff" || echo "Script Fail"
exit 0

