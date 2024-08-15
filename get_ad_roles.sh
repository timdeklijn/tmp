#!/bin/bash

# collect all roles that are assigned to AD groups. These are usually not
# bound to subscriptions so we simply request all roles and then filter based
# on the metadata.

# when queying all roles it matters what subscription is active at the moment.
# We need all our subscriptions to found all roles, loop over them and
# collect all roles.
subscriptions=( \
	"1b0bfa60-e350-4232-a276-933ac0f4c73c" \
	"13c5f815-4abf-4dc5-b5a5-e3da8f4ed61c" \
	"e21dbe36-bce0-4e73-b54a-c422a0f34d4b" \
	"8ebc328a-2290-49b0-9edd-3a78d009bc90" \
	"38367b2c-01ce-43dd-a77a-094dca7e7883" \
	"c57814ef-405a-4338-948c-198cabde72dc" \
	"b39e003f-9b49-409f-814c-98f086d7d81a" \
	"41a62200-efb3-43bd-b0d7-900fc12c89be" \
	"26c3aab2-cf3d-4b32-bae3-0108581b2f7d" \
	"57d5c50a-6655-47d9-aafb-8346e5de62f9" \
)

# Base json object to append results of the queries to.
JSON=$(jq -n ".")

for sub in "${subscriptions[@]}"
do
	# switch subscription to list all active roles under that subscription.
	az account set --subscription $sub
	az account show

	# There are a lot of high level scoped roles that we are not interested in.
	# For now simply select the roles that have the scope 'resourceGroup'. 
	groups=$(az role assignment list --all \
		| jq -c '[. [] | select( 
			(.principalType == "Group") and (.resourceGroup != null) 
		)]')

	# Get the fields we are interested in:
	filtered=$(echo $groups | \
		jq -c '[.[] | {
			principalType,
			principalId,
			principalName,
			roleDefinitionName,
			resourceGroup,
			createdBy
		}]')

	# Append the found roles to the json
	JSON="$(echo "$JSON" | jq -c --argjson p "$filtered" '. += $p')"
done

echo $JSON | jq .
echo $JSON | jq . > ad_roles.json