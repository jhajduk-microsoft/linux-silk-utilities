#!/bin/bash

# Function to print error message and exit
error_exit()
{
    echo "Error: $1" 1>&2
    exit 1
}

# Create physical volumes
pvcreate /dev/mapper/mpathb /dev/mapper/mpathc /dev/mapper/mpathd /dev/mapper/mpathe /dev/mapper/mpathf /dev/mapper/mpathg /dev/mapper/mpathh /dev/mapper/mpathi ||
    error_exit "Failed to create initial physical volumes."

# Create volume group
vgcreate prdvg /dev/mapper/mpathb /dev/mapper/mpathc /dev/mapper/mpathd /dev/mapper/mpathe /dev/mapper/mpathf /dev/mapper/mpathg /dev/mapper/mpathh /dev/mapper/mpathi ||
    error_exit "Failed to create volume group."

# Create logical volume
lvcreate -L 80T -i 8 -I 4M -n epicprd01lv prdvg ||
    error_exit "Failed to create logical volume."

# Make XFS filesystem
mkfs.xfs /dev/mapper/prdvg-epicprd01lv ||
    error_exit "Failed to format the filesystem."

# Create mount directory
mkdir -p /epic/prd01 ||
    error_exit "Failed to create mount directory."

# Mount the filesystem
mount /dev/mapper/prdvg-epicprd01lv /epic/prd01 ||
    error_exit "Failed to mount the filesystem."

# Create additional physical volumes
pvcreate /dev/mapper/mpathaa1 /dev/mapper/mpathab1 /dev/mapper/mpathaf1 /dev/mapper/mpathae1 /dev/mapper/mpathag1 /dev/mapper/mpathah1 /dev/mapper/mpathac1 /dev/mapper/mpathad1 ||
    error_exit "Failed to create additional physical volumes."

# Add entries to /etc/fstab
echo "/dev/mapper/mpathai1 /epic/mdrp/jrn ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathai1."

echo "/dev/mapper/mpathaa1 /epic/mdrp01 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathaa1."

echo "/dev/mapper/mpathab1 /epic/mdrp02 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathab1."

echo "/dev/mapper/mpathac1 /epic/mdrp03 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathac1."

echo "/dev/mapper/mpathad1 /epic/mdrp04 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathad1."

echo "/dev/mapper/mpathae1 /epic/mdrp05 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathae1."

echo "/dev/mapper/mpathaf1 /epic/mdrp06 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathaf1."

echo "/dev/mapper/mpathag1 /epic/mdrp07 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathag1."

echo "/dev/mapper/mpathah1 /epic/mdrp08 ext4 _netdev 0 0" >> /etc/fstab ||
    error_exit "Failed to add fstab entry for mpathah1."

echo "All operations completed successfully."
