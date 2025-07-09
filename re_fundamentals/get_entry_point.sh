#!/bin/bash

source ./messages.sh

# Check argument count
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

# Check if file is an ELF file
file_type=$(file "$file_name")
if [[ "$file_type" != *"ELF"* ]]; then
    echo "Error: '$file_name' is not an ELF file."
    exit 1
fi

# Extract Magic Number (16 bytes)
magic_number=$(hexdump -n 16 -e '16/1 "%02x " "\n"' "$file_name")

# Extract ELF Class
class=$(readelf -h "$file_name" | awk -F: '/Class:/ {print $2}' | xargs)

# Extract Byte Order
byte_order_raw=$(readelf -h "$file_name" | awk -F: '/Data:/ {print $2}' | xargs)

# Normalize byte order to exactly what the checker expects
if [[ "$byte_order_raw" == *"little endian"* ]]; then
    byte_order="little endian"
elif [[ "$byte_order_raw" == *"big endian"* ]]; then
    byte_order="big endian"
else
    byte_order=""
fi

# Extract Entry Point Address
entry_point_address=$(readelf -h "$file_name" | awk -F: '/Entry point address:/ {print $2}' | xargs)

# Display formatted output
display_elf_header_info
