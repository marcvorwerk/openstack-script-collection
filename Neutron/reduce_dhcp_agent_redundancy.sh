#!/bin/env bash

# https://rodolfo-alonso.com/reduce-dhcp-agent-redundancy

for NETWORK in $(openstack network list --internal --enable -c ID -f value); do
  echo "NETWORK: $NETWORK"
  AGENTS=$(openstack network agent list --long --network "${NETWORK}" -f value -c ID)
  COUNT=$(echo "$AGENTS" | wc -w)
  if [[ "$COUNT" -eq "3" ]]; then
    #AGENT2RM=$(echo "$AGENTS" | tr '\n' ' ' | awk -v a=$(( $RANDOM % 3 +1 )) '{print $a}')
    AGENT2RM=$(echo "$AGENTS" | awk "NR==$(( $RANDOM % 3 +1 ))")
    #echo "We remove Agent $AGENT2RM"
    echo openstack network agent remove network --dhcp "$AGENT2RM" "$NETWORK"
    openstack network agent remove network --dhcp "$AGENT2RM" "$NETWORK"
  else
    echo "Skipping Network $NETWORK because the count of dhcp agents is $COUNT"
  fi
  echo
  echo
done
