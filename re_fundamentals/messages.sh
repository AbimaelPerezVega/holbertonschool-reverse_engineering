#!/bin/bash

function display_elf_header_info() {
    echo "ELF Header Information for '$file_name':"
    echo "----------------------------------------"
    echo "Magic Number: $magic_number"
    echo "Class: $class"
    echo "Byte Order: $byte_order"
    echo "Entry Point Address: $entry_point_address"
}

function display_error() {
    echo "Error: $1" >&2
}

function display_usage() {
    echo "Usage: $0 <elf_file>"
    echo "Example: $0 target_binary"
}