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
execute_command "sudo pvcreate /dev/sdg" "Creating Physical Volume: /dev/sdg"

# Create Volume Group (VG)
execute_command "sudo vgcreate prd /dev/sdg" "Creating Volume Group: uat"

# Create Logical Volume (LV)
execute_command "sudo lvcreate -L 1T -i 1 -I 2M -n epiclv uat" "Creating Logical Volume: epiclv"

# Format the Logical Volume with XFS
execute_command "sudo mkfs.xfs /dev/uat/epiclv" "Formatting Logical Volume as XFS"

# Create directories
execute_command "sudo mkdir -p /epic6/uat" "Creating Directories: /epic6/uat"

# Change to the /epic3 directory
cd /epic6 || handle_error "Changing to directory /epic6 failed"

# Exit the script
exit 0
