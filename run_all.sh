#!/bin/bash
#
# Simple script that calls all 'role getters' in a row. Simpy to not have to
# run more then one command.

GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}getting managed identity roles${NC}"
./get_mi_roles.sh

echo -e "${GREEN}getting app registration roles${NC}"
./get_appreg_roles.sh

echo -e "${GREEN}getting active directory roles${NC}"
./get_ad_roles.sh 