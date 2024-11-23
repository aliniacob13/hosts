#!/bin/bash

cat /etc/hosts | while read -r ip name; do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    resolved_ip=$(nslookup "$name" 2>/dev/null | grep -A1 "Name:" | grep "Address:" | tail -n1 | awk '{print $2}')
    
    if [[ "$resolved_ip" != "$ip" && -n "$resolved_ip" ]]; then
        echo "Bogus IP for $name in /etc/hosts!"
    fi
done
