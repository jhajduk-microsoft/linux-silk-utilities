#!/bin/bash

# Function to handle errors and exit the script
handle_error() {
    echo "Error: $1"
    exit 1
}

# Function to execute a command with error handling
execute_command() {
    local cmd="$1"
    local description="$2"
    
    echo "Executing: $description"
    
    # Run the command and capture the exit code
    if ! eval "$cmd"; then
        handle_error "$description failed"
    fi
}

# Perform the required actions with error handling

# Create Physical Volumes (PVs)
pvcreate_cmds=(
    "/dev/mapper/mpathb"
    "/dev/mapper/mpathc"
    "/dev/mapper/mpathd"
    "/dev/mapper/mpathe"
    "/dev/mapper/mpathf"
    "/dev/mapper/mpathg"
    "/dev/mapper/mpathh"
    "/dev/mapper/mpathi"
)

for pv_cmd in "${pvcreate_cmds[@]}"; do
    execute_command "pvcreate $pv_cmd" "Creating Physical Volume: $pv_cmd"
done

# Create Volume Group (VG)
execute_command "vgcreate prdvg /dev/mapper/mpathb /dev/mapper/mpathc /dev/mapper/mpathd /dev/mapper/mpathe /dev/mapper/mpathf /dev/mapper/mpathg /dev/mapper/mpathh /dev/mapper/mpathi" "Creating Volume Group: prdvg"

# Create Logical Volume (LV)
execute_command "lvcreate -L 80T -i 8 -I 4M -n epicprd01lv prdvg" "Creating Logical Volume: epicprd01lv"

# Format the Logical Volume with XFS
execute_command "mkfs.xfs /dev/mapper/prdvg-epicprd01lv" "Formatting Logical Volume as XFS"

# Create mount directory
execute_command "mkdir -p /epic/prd01" "Creating Mount Directory: /epic/prd01"

# Mount the Logical Volume
execute_command "mount /dev/mapper/prdvg-epicprd01lv /epic/prd01" "Mounting Logical Volume to /epic/prd01"

# Create Physical Volumes for the second set
pvcreate_cmds=(
    "/dev/mapper/mpathaa1"
    "/dev/mapper/mpathab1"
    "/dev/mapper/mpathaf1"
    "/dev/mapper/mpathae1"
    "/dev/mapper/mpathag1"
    "/dev/mapper/mpathah1"
    "/dev/mapper/mpathac1"
    "/dev/mapper/mpathad1"
    "/dev/mapper/mpathai1"
)

for pv_cmd in "${pvcreate_cmds[@]}"; do
    execute_command "pvcreate $pv_cmd" "Creating Physical Volume: $pv_cmd"
done

# Add your remaining commands here for mounting, etc.

# Handle completion
echo "All commands executed successfully."
