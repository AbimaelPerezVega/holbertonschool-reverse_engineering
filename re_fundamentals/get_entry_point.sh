#!/bin/bash

source ./messages.sh

# Check input
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <ELF file>"
    exit 1
fi

file_name="$1"

# Check if file exists
if [[ ! -f "$file_name" ]]; then
    echo "Error: File '$file_name' not found."
    exit 1
fi

# Check if it's an ELF file
file_type=$(file "$file_name")
if [[ "$file_type" != *"ELF"* ]]; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

# Extract ELF Header Info
magic_number=$(hexdump -n 16 -e '16/1 "%02x " "\n"' "$file_name")
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | awk -F: '{print $2}' | xargs)

# Normalize byte order
if [[ "$byte_order" == *"little endian"* ]]; then
    byte_order="little endian"
elif [[ "$byte_order" == *"big endian"* ]]; then
    byte_order="big endian"
fi

entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# Display output
display_elf_header_info
