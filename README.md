# Linux Silk Utilities - WIP, Needs to be tested on Silk machines

These utility scripts are meant to assist in creating the specific olumes needed in a Linux Silk machine. These scripts will need to be tested and modified for your use cases.

## Prerequisites

* Visual Studio Code or any development editor
* PowerShell extension for VSCode or PowerShell installed natively on Windows
* JSON and Markdown extensions may be helpful if using VSCode

## Files

* computerNamesOrIPs.txt is a list of prepolulated computer names or IPs of Silk machines that will need the volume configuration
* find-silkGUID.ps1. This is a helpful utility script that can return the Vendor Spcific property of the sdparm command in a Silk machine. This will need to be edited and played with until the exact value is returned. You will want to comment out lines 43 and 44. The output is a file that will be generated that contains the computer name and the associated vendor speciifc GUID is the following format: computername or IP,GUID. This will help in no having to log onto each machine to get the GUIDs.
* volumeMapping.json and testVolumeCreation. This JSON file contains a key (guid) and the mapping that should be associated with that GUID. I used a test JSON file as I do not have a Silk machine to test on.
* create-silkvolumes.ps1. This script will create the Silk volumes based on a key from the volumeMapping.json. It also uses the computerNamesOrIps.txt file to know which machines to log into to perform the volume mapping.