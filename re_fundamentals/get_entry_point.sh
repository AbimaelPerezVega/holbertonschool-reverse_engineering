#!/bin/bash

# Source the messages.sh file for display functions
source messages.sh

# Check if argument is provided
if [ $# -ne 1 ]; then
    display_usage
    exit 1
fi

file_name="$1"

# Check if file exists
if [ ! -f "$file_name" ]; then
    display_error "File '$file_name' does not exist."
    exit 1
fi

# Check if file is readable
if [ ! -r "$file_name" ]; then
    display_error "File '$file_name' is not readable."
    exit 1
fi

# Check if file is an ELF file using file command
if ! file "$file_name" | grep -q "ELF"; then
    display_error "File '$file_name' is not a valid ELF file."
    exit 1
fi

# Extract ELF header information using readelf
elf_header=$(readelf -h "$file_name" 2>/dev/null)

# Check if readelf command was successful
if [ $? -ne 0 ]; then
    display_error "Failed to read ELF header from '$file_name'."
    exit 1
fi

# Extract specific information from the ELF header
magic_number=$(echo "$elf_header" | grep "Magic:" | awk '{for(i=2;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
class=$(echo "$elf_header" | grep "Class:" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//')
# Extract only the endianness part after the comma
byte_order=$(echo "$elf_header" | grep "Data:" | sed 's/.*,\s*//')
entry_point_address=$(echo "$elf_header" | grep "Entry point address:" | awk -F: '{print $2}' | sed 's/^[[:space:]]*//')

# Validate that all required information was extracted
if [ -z "$magic_number" ] || [ -z "$class" ] || [ -z "$byte_order" ] || [ -z "$entry_point_address" ]; then
    display_error "Failed to extract complete ELF header information from '$file_name'."
    exit 1
fi

# Display the extracted information using the messages.sh function
display_elf_header_info