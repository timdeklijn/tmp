#!/bin/bash

# * AR20ZPZ001-PP                            - 1600476b-bea0-49ca-b784-1be26ceb8517
# * ar20ndov001-p                            - 1e49da6e-7a02-429b-ad65-5054cc0cdbcf
# * ar20admonitor001-p                       - 22f82875-c5ca-47aa-a6d8-207af7f19a0b
# * AR20CROWDEDNESSUPDATESINGESTION001-P     - 2c43fca5-f96f-4a6d-8dbd-82afa75e0008
# * RA20DNAAAKDevOpsDP-Staging               - 30632d26-c293-4023-9679-35599957d8ef
# * DNAKAA APIM SP TenA                      - 36e68cd1-0995-4f20-9dc5-c60b9901733b
# * AR20CROWDEDNESSUPDATESINGESTION001-O     - 443f4f83-9f92-4382-bb4f-364157074534
# * ar20sigmaacl001-o                        - 4a060620-e642-4581-b0cc-56c08ae5b3ab
# * AR20CROWDEDNESSUPDATESINGESTION001-T     - 4f33a0de-3b8c-483c-8779-2af805230a73
# * ar20monitor001-t                         - 555ff54d-7cd8-4012-b571-43ae16216172
# * ar20crowdednessapi001-t                  - 5917fc00-5f29-4a1c-9e80-9771d5dc03c4
# * ar20monitor001-p                         - 5ad87007-afd1-418b-b32c-8b1888578972
# * AR20PARSER001-PP                         - 5bd2535d-8a33-453b-aefb-b4664c964277
# * ar20monitor001-o                         - 6cc5a5f8-0a21-47ca-af3c-cce4393acc93
# * ar20ndov001-t                            - 7826c45c-ca07-48fd-986e-8742e8494715
# * ar20parser001-p                          - 7d2c6df7-8dc7-4223-badb-ab69eb1a9d7e
# * AR20DEVAAPLATFORM100-O                   - 828c8174-7268-4526-8285-da9d794e371a
# * AR20CROWDEDNESSUPDATESINGESTION001-A     - 852405a5-9f0b-4cbd-bb84-173c24663e35
# * AR20DOVA001-A                            - 8de046f0-21eb-40ec-8d18-e8731f9396bf
# * RA20DNAAAKDevOpsDP-Prod                  - 93cf2733-9b9e-4257-b51d-e58117edd47e
# * ar20dova001-o                            - 993f0485-77fd-464c-b892-18911fef5393
# * ar20sigmaacrpull001-p                    - 9ab002b0-a406-4fb6-933b-16afc936f9a6
# * AR20ZPZ001-A                             - a928704a-dba0-4a1e-b165-acf291586759
# * ar20zpz001-p                             - b0d85287-9a1a-472c-8e0b-bf6357cd1258
# * ar20sigmaacl001-t                        - b539372e-18a4-4d42-bc47-739346b5c3c6
# * AR20NDOV001-A                            - b8225475-cba2-409f-a29a-3bf0e7f0e7d7
# * ar20crowdednessapi001-o                  - ba79d5c9-46a5-485b-9096-64e3bdd1086e
# * ar20aad-token                            - bb67371c-a642-40b1-9d9e-e7b70234b95c
# * ar20dova001-p                            - be80a94a-2552-496c-8cd5-05fe6529be04
# * AR20CROWDEDNESSAPI001-A                  - c4c5b0f3-5e14-4127-b0eb-d78b7932729d
# * ar20sigmaacl001-p                        - c93b95a8-4549-4462-ba8b-f7b68c4c0f02
# * ar20dova001-t                            - cc7e2d26-9ac1-4114-ae0b-cc49922d3896
# * AR20PARSER001-A                          - d0d4a2ba-2809-479f-a677-e1212575e056
# * ar20zpz001-o                             - d7705655-697c-4c5f-9dae-249654e34cc6
# * AR20DEV-DNA-AAKLANT                      - dbaf3888-13ca-4007-8a08-bcda0cfc69cf
# * AR20SIGMAACRPUSH001-P                    - dd3f52b2-b8f3-4b66-93fc-e0c21aa47654
# * DNAKAA APIM SP P                         - e47b93b2-2750-41b8-836d-88ae7c1f0849
# * ar20parser001-t                          - ec78586c-e0a3-4355-b2e3-90c44881615d
# * ar20zpz001-t                             - f2547f3e-ee87-4dc6-9ced-97ab10cf39e7
# * ar20ndov001-o                            - f59a9a31-5b17-44c7-82d8-5e3688282a0a
# * ar20parser001-o                          - f5fa5aa7-7b80-4024-bd02-83825ecfca30
# * ar20crowdednessapi001-p                  - fa11d962-2901-4ef6-bc51-4784aa538edc

# we need the names of the app registrations to get the service principles
# required to get the roles.
APP_REG_DISPLAY_NAMES=("AR20ZPZ001-PP" "ar20ndov001-p" "ar20admonitor001-p" "AR20CROWDEDNESSUPDATESINGESTION001-P" "RA20DNAAAKDevOpsDP-Staging" "DNAKAA APIM SP TenA" "AR20CROWDEDNESSUPDATESINGESTION001-O" "ar20sigmaacl001-o" "AR20CROWDEDNESSUPDATESINGESTION001-T" "ar20monitor001-t" "ar20crowdednessapi001-t" "ar20monitor001-p" "AR20PARSER001-PP" "ar20monitor001-o" "ar20ndov001-t" "ar20parser001-p" "AR20DEVAAPLATFORM100-O" "AR20CROWDEDNESSUPDATESINGESTION001-A" "AR20DOVA001-A" "RA20DNAAAKDevOpsDP-Prod" "ar20dova001-o" "ar20sigmaacrpull001-p" "AR20ZPZ001-A" "ar20zpz001-p" "ar20sigmaacl001-t" "AR20NDOV001-A" "ar20crowdednessapi001-o" "ar20aad-token" "ar20dova001-p" "AR20CROWDEDNESSAPI001-A" "ar20sigmaacl001-p" "ar20dova001-t" "AR20PARSER001-A" "ar20zpz001-o" "AR20DEV-DNA-AAKLANT" "AR20SIGMAACRPUSH001-P" "DNAKAA APIM SP P" "ar20parser001-t" "ar20zpz001-t" "ar20ndov001-o" "ar20parser001-o" "ar20crowdednessapi001-p" )

# An empty JSON object we append the results to
JSON=$(jq -n "")

for ar in "${APP_REG_DISPLAY_NAMES[@]}"
do
	# Get the service principle for the app registration. Skip if none are
	# found.
	service_principles=$(az ad sp list \
	      --display-name "$ar" \
	      --query [].id \
	      --output tsv)

	if [ -z "$service_principles" ]; then
		continue
	fi

	# Somehow the query for service principles can result in multiple service
	# principles per app-reg. Simply look up the roles for all of them.
	for sp in $service_principles
	do
		roles=$(az role assignment list \
		        --assignee $sp \
		        --query [].roleDefinitionName \
		        --all \
		        -o tsv)
	
		if [ -z "$roles" ]; then
    		continue
  		fi

  		# save the results in a json object for this specific query
		tmp=$(echo $JSON | jq \
			--arg "name" "$ar" \
			--arg "service_principle" "$sp" \
			--arg "roles" "$roles" \
			'. += {($name): {"service_principle": $service_principle, "roles": $roles}}')
		# append the results to the JSON object
		JSON=$(echo JSON | jq -n "$tmp")
	done
done

# Save to file
date=$(date '+%Y%m%d%H%M%S')
echo $JSON | jq > "${date}_appreg_roles.json"
echo "Done"