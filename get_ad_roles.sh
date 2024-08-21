#!/bin/bash

# collect all roles that are assigned to AD groups. These are usually not
# bound to subscriptions so we simply request all roles and then filter based
# on the metadata.

# when querying all roles it matters what subscription is active at the
# moment. We need all our subscriptions to found all roles, loop over them
# and collect all roles. We get the subscription IDs from the file
# `subscriptions.txt`.
subscriptions=$(cat subscriptions.txt)

# Base json object to append results of the queries to.
JSON=$(jq -n ".")

for sub in $subscriptions
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
date=$(date '+%Y%m%d%H%M%S')
echo $JSON | jq . > "${date}_ad_roles.json"