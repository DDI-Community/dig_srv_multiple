#!/bin/bash

# Check if SRVrecords.txt exists
if [ ! -f SRVrecords.txt ]; then
    echo "SRVrecords.txt not found! Please create the file and list SRV records in it."
    exit 1
fi

# Check if a DNS server was provided as an argument
if [ $# -eq 0 ]; then
    echo "No DNS server specified. Using the default DNS server."
    dns_server=""
else
    dns_server="@${1}"
    echo "Using DNS server: $1"
fi

# Read each line from SRVrecords.txt and run dig for SRV records
while read -r srv_record; do
    if [[ -n "$srv_record" ]]; then
        echo "Resolving SRV record: $srv_record"
        dig +short SRV "$srv_record" $dns_server
        echo ""
    fi
done < SRVrecords.txt
