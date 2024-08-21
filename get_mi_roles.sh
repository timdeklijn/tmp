#!/bin/bash
# 
# A simple script to find all managed identities in a subscription and list
# the assigned roles. we need these roles because we need to reassign them
# when we move our subscription from the current setting to one that we can
# manage our own roles (using terraform). 
# 
# we get the list of relevant subscriptions from the file
# `subscriptions.txt`.
subscriptions=$(cat subscriptions.txt)

# append to this JSON object
JSON=$(jq -n "")

for sub in $subscriptions
do
  # Get the list of managed identities
  mi_names=$(az identity list \
    --subscription $sub \
    --query [].name -o tsv)

  if [ -z "$mi_names" ]; then
    continue
  fi

  for mi_name in $mi_names
  do
    echo $mi_name
    # get the service principles for the managed identity
    service_principles=$(az ad sp list \
      --display-name "$mi_name" \
      --query [].id \
      --output tsv)

    if [ -z "$service_principles" ]; then
      continue
    fi

    # loop over the service principles
    for sp in $service_principles
    do
      echo "> $sp"
      # get the roles assigned to the service principle.
      #
      # NOTE: the `-all` flag is required to find all roles. Without it 90% of
      # the roles are not found
      roles=$(az role assignment list \
        --assignee $sp \
        --query [].roleDefinitionName \
        --all \
        -o tsv)
  
      # if there are no roles assigned to the service principles simply skip it
      if [ -z "$roles" ]; then
        continue
      fi
  
      # create a json object like:
      # {"<mi_name>" : {"service_principle": "<sp>", "roles": "<roles>" }}
      # then append it to the json object
      tmp=$(echo $JSON | jq \
        --arg "mi_name" "$mi_name" \
        --arg "sp" "$sp" \
        --arg "roles" "$roles" \
        '. += {($mi_name): {"service_principle": $sp, "roles": $roles}}')

      echo "> > $tmp"
      JSON=$(echo JSON | jq -n "$tmp")
    done
  done
done

echo $JSON
date=$(date '+%Y%m%d%H%M%S')
echo $JSON | jq > "${date}_mi_roles.json"
echo "done"