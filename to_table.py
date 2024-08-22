"""to_table.py

Quick and dirty script to convert an output json file to a markdown table. 

Read a file, create a pandas dataframe from the unpacked data and write the
table to a markdown table.
"""

import json

import click
import pandas as pd


def managed_identities(file: str) -> str:
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
    df = pd.DataFrame({"name": name, "role": role_list, "sp": sp})
    m = df.to_markdown()
    if m is None:
        print("ERROR: app reg df is None")
        exit(1)
    return m


def app_registrations(file: str) -> str:
    with open(file, "r") as f:
        data = json.load(f)

    name, role_list, sp = [], [], []
    for k, v in data.items():
        roles = v["roles"].split("\n")
        for role in roles:
            name.append(k)
            role_list.append(role)
            sp.append(v["service_principle"])
    df = pd.DataFrame({"name": name, "role": role_list, "sp": sp})
    m = df.to_markdown()
    if m is None:
        print("ERROR: app reg df is None")
        exit(1)
    return m


def ad_groups(file: str) -> str:
    with open(file, "r") as f:
        data = json.load(f)

    rg, roles, pi, pn = [], [], [], []
    for d in data:
        rg.append(d["resourceGroup"])
        roles.append(d["roleDefinitionName"])
        pi.append(d["principalId"])
        pn.append(d["principalName"])

    df = pd.DataFrame(
        {"resourceGroup": rg, "role": roles, "principalId": pi, "principalName": pn}
    )
    m = df.to_markdown()
    if m is None:
        print("ERROR: ad group df is None")
        exit(1)
    return m


def combine(tables: dict[str, str], output: str) -> None:
    with open(output, "w") as f:
        # first add a markdown header
        f.write("# Roles Team Drukte\n\n")
        for k, v in tables.items():
            f.write(f"## {k}\n\n")
            f.write(v)
            f.write("\n\n")


@click.command()
@click.option("--mi-file", help="json file with managed identities roles")
@click.option("--appreg-file", help="json file with app registration roles")
@click.option("--ad-file", help="json file with AD roles")
@click.option("--output", default="roles.md", help="name of output file")
def main(mi_file: str, appreg_file: str, ad_file: str, output: str):
    """run the whole script."""
    output_tables: dict[str, str] = {}
    output_tables["AD Group Roles"] = ad_groups(ad_file)
    output_tables["Managed Identities Roles"] = managed_identities(mi_file)
    output_tables["App Registration Roles"] = app_registrations(appreg_file)
    combine(output_tables, output)
    print("Wrote output to", output)


if __name__ == "__main__":
    main()
