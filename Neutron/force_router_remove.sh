#!/bin/bash

input=$1
uuid_pattern="^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
if [[ $input =~ $uuid_pattern ]]; then
	ROUTER_ID=$input
else
	echo "Error - '$1' is not a vailid Router UUID"
	exit 1
fi

openstack router unset --external-gateway ${ROUTER_ID}

for PORT in $(openstack port list --router ${ROUTER_ID} -f value -c ID); do
	openstack router remove port ${ROUTER_ID} ${PORT}
done
