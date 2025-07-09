#!/bin/bash

# Load display function
source ./messages.sh

# Check input
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Check file exists
if [[ ! -f "$file_name" ]]; then
    echo "Error: File '$file_name' not found."
    exit 1
fi

# Check it's an ELF file
file_type=$(file "$file_name")
if [[ "$file_type" != *"ELF"* ]]; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

# Extract ELF fields using readelf
magic_number=$(hexdump -n 4 -e '4/1 "%02x "' "$file_name")
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk '{print $2, $3, $4}')
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Display the output
display_elf_header_info
