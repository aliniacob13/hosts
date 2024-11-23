#!/bin/bash

validate_ip() {
    local name=$1
    local ip=$2
    local dns_server=$3

    resolved_ip=$(nslookup "$name" "$dns_server" 2>/dev/null | grep -A1 "Name:" | grep "Address:" | tail -n1 | awk '{print $2}')

    if [[ "$resolved_ip" != "$ip" && -n "$resolved_ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
}

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    validate_ip "$name" "$ip" "8.8.8.8"
done

