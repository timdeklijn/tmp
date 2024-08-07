#!/bin/bash
# 
# A simple script to find all managed identities in a subscription and list
# the assigned roles. we need these roles because we need to reassign them
# when we move our subscription from the current setting to one that we can
# manage our own roles (using terraform). 

subscriptions=( "1b0bfa60-e350-4232-a276-933ac0f4c73c" "13c5f815-4abf-4dc5-b5a5-e3da8f4ed61c" "e21dbe36-bce0-4e73-b54a-c422a0f34d4b" "8ebc328a-2290-49b0-9edd-3a78d009bc90" "38367b2c-01ce-43dd-a77a-094dca7e7883" "c57814ef-405a-4338-948c-198cabde72dc" "b39e003f-9b49-409f-814c-98f086d7d81a" "41a62200-efb3-43bd-b0d7-900fc12c89be" "26c3aab2-cf3d-4b32-bae3-0108581b2f7d" "57d5c50a-6655-47d9-aafb-8346e5de62f9" )

# append to this JSON object
JSON=$(jq -n "")

for sub in "${subscriptions[@]}"
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
      # get the roles assigned to the service principle
      roles=$(az role assignment list \
        --assignee $sp \
        --query [].roleDefinitionName \
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
      JSON=$(echo JSON | jq -n "$tmp")
    done
  done
done

echo $JSON | jq > mi_roles.json
echo "done"