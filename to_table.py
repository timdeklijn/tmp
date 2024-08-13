"""to_table.py

Quick and dirty script to convert an output json file to a markdown table. 

Read a file, create a pandas dataframe from the unpacked data and write the
table to a markdown table.
"""

import json

import pandas as pd

RAW_MI_DATA = "20240808_mi_roles.json"
RAW_APP_REG_DATA = "20240813_app_reg_roles.json"
OUTPUT = "roles_table.md"

if __name__ == "__main__":

    # ==========================================================================
    # Managed Identities
    # ==========================================================================

    # read the data
    with open(RAW_MI_DATA, "r") as f:
        data = json.load(f)

    # unpack the data into a table. In the data the roles are stored as a
    # string and `\n` is used to separate the roles. Split these and
    # duplicate the other value per role.
    name, role_list, sp = [], [], []
    for k, v in data.items():
        roles = v["roles"].split("\n")
        for role in roles:
            name.append(k)
            role_list.append(role)
            sp.append(v["service_principle"])

    # create a pandas dataframe so we can format an output table.
    mi_df = pd.DataFrame({"name": name, "role": role_list, "sp": sp})

    # ==========================================================================
    # App registrations
    # ==========================================================================

    with open(RAW_APP_REG_DATA, "r") as f:
        data = json.load(f)

    name, role_list, sp = [], [], []
    for k, v in data.items():
        roles = v["roles"].split("\n")
        for role in roles:
            name.append(k)
            role_list.append(role)
            sp.append(v["service_principle"])
    ar_df = pd.DataFrame({"name": name, "role": role_list, "sp": sp})

    # ==========================================================================
    # Write the table to a markdown file
    # ==========================================================================

    out_df = pd.concat([mi_df, ar_df]).reset_index(drop=True, inplace=False)

    table = out_df.to_markdown()  # NOTE: the package `tabulate` is required to run this
    # Exit if `table` is None. Should not happen, but `to_markdown()` returns
    # an optional.
    if table is None:
        print("ERROR: `table` is None")
        exit(1)

    with open(OUTPUT, "w") as f:
        # first add a markdown header
        f.write("# Managed Identity Roles\n\n")
        # Then write the table
        f.write(table)
