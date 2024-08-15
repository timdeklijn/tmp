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

RAW_AD_DATA = "ad_roles.json"
AD_OUTPUT = "ad_roles_table.md"


def managed_identities() -> pd.DataFrame:
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
    return mi_df


def app_registrations() -> pd.DataFrame:
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
    return ar_df

def ad_groups() -> pd.DataFrame:
    with open(RAW_AD_DATA, "r") as f:
        data = json.load(f)

    rg, roles, pi, pn = [], [], [], []
    for d in data:
        rg.append(d["resourceGroup"])
        roles.append(d["roleDefinitionName"])
        pi.append(d["principalId"])
        pn.append(d["principalName"])

    ad_df = pd.DataFrame({"resourceGroup": rg, "role": roles, "principalId": pi, "principalName": pn})
    return ad_df


def combine(dfs: list[pd.DataFrame]) -> None:
    out_df = pd.concat(dfs).reset_index(drop=True, inplace=False)

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


if __name__ == "__main__":
    df = ad_groups()
    t = df.to_markdown()
    if t is None:
        exit(1)
    with open("tmp.md", "w") as f:
        # first add a markdown header
        f.write("# Managed Identity Roles\n\n")
        # Then write the table
        f.write(t)
    print(t)
    exit()
    mi_df = managed_identities()
    ar_df = app_registrations()
    combine([mi_df, ar_df])
    print("Wrote output to", OUTPUT)
