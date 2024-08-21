"""to_table.py

Quick and dirty script to convert an output json file to a markdown table. 

Read a file, create a pandas dataframe from the unpacked data and write the
table to a markdown table.
"""

import json

import click
import pandas as pd


def managed_identities(file: str) -> pd.DataFrame:
    # read the data
    with open(file, "r") as f:
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


def app_registrations(file: str) -> pd.DataFrame:
    with open(file, "r") as f:
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


def ad_groups(file: str) -> pd.DataFrame:
    with open(file, "r") as f:
        data = json.load(f)

    rg, roles, pi, pn = [], [], [], []
    for d in data:
        rg.append(d["resourceGroup"])
        roles.append(d["roleDefinitionName"])
        pi.append(d["principalId"])
        pn.append(d["principalName"])

    ad_df = pd.DataFrame(
        {"resourceGroup": rg, "role": roles, "principalId": pi, "principalName": pn}
    )
    return ad_df


def combine(dfs: list[pd.DataFrame], output: str) -> None:
    out_df = pd.concat(dfs).reset_index(drop=True, inplace=False)

    table = out_df.to_markdown()  # NOTE: the package `tabulate` is required to run this
    # Exit if `table` is None. Should not happen, but `to_markdown()` returns
    # an optional.
    if table is None:
        print("ERROR: `table` is None")
        exit(1)

    with open(output, "w") as f:
        # first add a markdown header
        f.write("# Managed Identity Roles\n\n")
        # Then write the table
        f.write(table)


@click.command()
@click.option("--mi-file", help="json file with managed identities roles")
@click.option("--appreg-file", help="json file with app registration roles")
@click.option("--ad-file", help="json file with AD roles")
@click.option("--output", default="roles.md", help="name of output file")
def main(mi_file: str, appreg_file: str, ad_file: str, output: str):
    """run the whole script."""
    df = ad_groups(ad_file)
    t = df.to_markdown()
    if t is None:
        exit(1)
    with open(output, "w") as f:
        # first add a markdown header
        f.write("# Managed Identity Roles\n\n")
        # Then write the table
        f.write(t)
    print(t)
    exit()
    mi_df = managed_identities(mi_file)
    ar_df = app_registrations(appreg_file)
    combine([mi_df, ar_df])
    print("Wrote output to", OUTPUT)


if __name__ == "__main__":
    main()
