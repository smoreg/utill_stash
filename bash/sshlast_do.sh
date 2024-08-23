#!/bin/bash

# connected via ssh to last created today droplet from DO

HOSTIP=$(curl -s -X GET -H "Authorization: Bearer $TOKEN" "https://api.digitalocean.com/v2/droplets" | \
jq -r '.droplets[] | select(.created_at | startswith("'"$(date -u +"%Y-%m-%d")"'")) | .networks.v4[] | select(.type=="public") | .ip_address' | tail -n 1)

# Check if HOSTIP was found
if [ -z "$HOSTIP" ]; then
  echo "No droplets created today."
  exit 1
else
  echo "Connecting to droplet with IP: $HOSTIP"
  ssh root@$HOSTIP
fi

