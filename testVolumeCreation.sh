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

# Create Physical Volume (PV)
execute_command "sudo pvcreate /dev/sdb" "Creating Physical Volume: /dev/sdb"

# Create Volume Group (VG)
execute_command "sudo vgcreate pri2 /dev/sdb" "Creating Volume Group: pri2"

# Create Logical Volume (LV)
execute_command "sudo lvcreate -L 1T -i 1 -I 2M -n epicprd0ilv2 pri2" "Creating Logical Volume: epicprd0ilv2"

# Format the Logical Volume with XFS
execute_command "sudo mkfs.xfs /dev/pri2/epicprd0ilv2" "Formatting Logical Volume as XFS"

# Create directories
execute_command "sudo mkdir -p /epic3/prd013" "Creating Directories: /epic3/prd013"

# Change to the /epic3 directory
cd /epic3 || handle_error "Changing to directory /epic3 failed"

# Exit the script
exit 0
