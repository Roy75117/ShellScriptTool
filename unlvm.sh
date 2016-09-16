#!/bin/bash
#echo -e "o\nd\nd\nn\np\n1\n\nt\n8e\nw" | fdisk /dev/sdb
#echo -e "o\nd\nd\nn\np\n1\n\nt\n8e\nw" | fdisk /dev/sdc
#echo -e "o\nd\nd\nn\np\n1\n\nt\n8e\nw" | fdisk /dev/sdd
#echo -e "o\nd\nd\nn\np\n1\n\nt\n8e\nw" | fdisk /dev/sde

declare -i count=0
umount /mnt/stuff
lvremove /dev/vgpool/lvstuff
vgremove vgpool
for var in {a..z}
do
	pvremove /dev/sd"$var"1

done

