# Migratie Drukte subscriptie naar nieuwe RBAC structuur

## Scope van de migratie

Een resultaat van deze migratie is dat de rollen die aan onze **managed
identities** zijn toegewezen door ns cloud verdwijnen. Deze kunnen we dan
zelf aan de **managed identities** hangen tijdens onze infra uitrol
(`terraform`).

Om de omvang van de migratie te bepalen moeten we weten om hoeveel **managed
identities** / **rollen** het gaat. Daarom hebben we een al onze subscripties
gescraped op **managed identities** en de rollen van elke **managed identy**
opgevraagd. Dit hebben we gedaan  door middel van een `bash` script en een
`python` programaatje om de output te formateren.

Dit zijn de resultaten:

|    | managed identity                   | role                                             | service principle                    |
|---:|:-----------------------------------|:-------------------------------------------------|:-------------------------------------|
|  0 | mi20containerpull001-o             | AcrPull                                          | d89d4398-4a13-4c00-8387-9cb77991fe13 |
|  1 | mi20monfunc001-p                   | Storage File Data SMB Share Elevated Contributor | 65e73417-12da-448f-acc6-e9ecc9286ec2 |
|  2 | mi20monfunc001-p                   | Storage Blob Data Owner                          | 65e73417-12da-448f-acc6-e9ecc9286ec2 |
|  3 | mi20crowdednessapi001-p            | Storage File Data SMB Share Elevated Contributor | f0b4d88a-3066-4769-9256-8ee29e0e85a6 |
|  4 | mi20crowdednessapi001-p            | Storage Blob Data Owner                          | f0b4d88a-3066-4769-9256-8ee29e0e85a6 |
|  5 | mi20crowdednessapi001-p            | DocumentDB Account Contributor                   | f0b4d88a-3066-4769-9256-8ee29e0e85a6 |
|  6 | mi20crowdednessapi001-p            | Cosmos DB Account Reader Role                    | f0b4d88a-3066-4769-9256-8ee29e0e85a6 |
|  7 | mi20crowdednessapi001-p            | Azure Event Hubs Data Receiver                   | f0b4d88a-3066-4769-9256-8ee29e0e85a6 |
|  8 | mi20ppvstream001-p                 | Storage File Data SMB Share Elevated Contributor | 2973f7e3-b76e-4e16-a79e-f2eb1bc3b028 |
|  9 | mi20ppvstream001-p                 | Storage Blob Data Owner                          | 2973f7e3-b76e-4e16-a79e-f2eb1bc3b028 |
| 10 | mi20ppvstream001-p                 | Azure Event Hubs Data Sender                     | 2973f7e3-b76e-4e16-a79e-f2eb1bc3b028 |
| 11 | mi20ppvstream001-p                 | Azure Event Hubs Data Receiver                   | 2973f7e3-b76e-4e16-a79e-f2eb1bc3b028 |
| 12 | mi20crowdednessupdates001-a        | Azure Event Hubs Data Receiver                   | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 13 | mi20crowdednessupdates001-a        | Storage Blob Data Owner                          | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 14 | mi20crowdednessupdates001-a        | Storage Table Data Contributor                   | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 15 | mi20crowdednessupdates001-a        | Storage Queue Data Contributor                   | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 16 | mi20crowdednessupdates001-a        | Storage File Data SMB Share Elevated Contributor | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 17 | mi20crowdednessupdates001-a        | Storage Blob Data Owner                          | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 18 | mi20crowdednessupdates001-a        | Azure Event Hubs Data Receiver                   | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 19 | mi20crowdednessupdates001-a        | Cosmos DB Account Reader Role                    | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 20 | mi20crowdednessupdates001-a        | Azure Event Hubs Data Sender                     | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 21 | mi20crowdednessupdates001-a        | Azure Event Hubs Data Receiver                   | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 22 | mi20crowdednessupdates001-a        | Azure Event Hubs Data Owner                      | 0512e2ad-d1dc-4f09-b3b0-7115bc330148 |
| 23 | mi20crowdednessupdates001-p        | Azure Event Hubs Data Receiver                   | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 24 | mi20crowdednessupdates001-p        | Storage Blob Data Owner                          | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 25 | mi20crowdednessupdates001-p        | Azure Event Hubs Data Receiver                   | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 26 | mi20crowdednessupdates001-p        | Storage Table Data Contributor                   | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 27 | mi20crowdednessupdates001-p        | Storage Queue Data Contributor                   | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 28 | mi20crowdednessupdates001-p        | Storage File Data SMB Share Elevated Contributor | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 29 | mi20crowdednessupdates001-p        | Storage Blob Data Owner                          | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 30 | mi20crowdednessupdates001-p        | Cosmos DB Account Reader Role                    | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 31 | mi20crowdednessupdates001-p        | Azure Event Hubs Data Sender                     | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 32 | mi20crowdednessupdates001-p        | Azure Event Hubs Data Receiver                   | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 33 | mi20crowdednessupdates001-p        | Azure Event Hubs Data Owner                      | 6317c35b-308c-46a5-99b3-485e9f84f1dc |
| 34 | mi20crowdednessapi001-a            | Storage File Data SMB Share Elevated Contributor | 381e3eab-c49d-4d95-aafa-a59537873a36 |
| 35 | mi20crowdednessapi001-a            | Storage Blob Data Owner                          | 381e3eab-c49d-4d95-aafa-a59537873a36 |
| 36 | mi20crowdednessapi001-a            | DocumentDB Account Contributor                   | 381e3eab-c49d-4d95-aafa-a59537873a36 |
| 37 | mi20crowdednessapi001-a            | Cosmos DB Account Reader Role                    | 381e3eab-c49d-4d95-aafa-a59537873a36 |
| 38 | mi20crowdednessapi001-a            | Azure Event Hubs Data Receiver                   | 381e3eab-c49d-4d95-aafa-a59537873a36 |
| 39 | mi20containerpull001-p             | AcrPull                                          | e652518e-4848-4c42-8d35-31e7d5b27c5a |
| 40 | mi20getv2crowdedness001-a          | Storage Blob Data Reader                         | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 41 | mi20getv2crowdedness001-a          | Storage Table Data Contributor                   | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 42 | mi20getv2crowdedness001-a          | Storage Queue Data Contributor                   | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 43 | mi20getv2crowdedness001-a          | Storage File Data SMB Share Elevated Contributor | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 44 | mi20getv2crowdedness001-a          | Storage Blob Data Owner                          | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 45 | mi20getv2crowdedness001-a          | Azure Event Hubs Data Sender                     | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 46 | mi20getv2crowdedness001-a          | Azure Event Hubs Data Receiver                   | 7b42d6b6-80e0-4541-bb25-253feee0a091 |
| 47 | mi20getv1crowdedness001-a          | Storage Blob Data Reader                         | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 48 | mi20getv1crowdedness001-a          | Storage Table Data Contributor                   | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 49 | mi20getv1crowdedness001-a          | Storage Queue Data Contributor                   | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 50 | mi20getv1crowdedness001-a          | Storage File Data SMB Share Elevated Contributor | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 51 | mi20getv1crowdedness001-a          | Storage Blob Data Owner                          | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 52 | mi20getv1crowdedness001-a          | Azure Event Hubs Data Sender                     | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 53 | mi20getv1crowdedness001-a          | Azure Event Hubs Data Receiver                   | df65c16f-8000-47f8-bd86-59d0d1faff12 |
| 54 | mi20getv2crowdedness001-p          | Azure Event Hubs Data Receiver                   | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 55 | mi20getv2crowdedness001-p          | Storage Table Data Contributor                   | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 56 | mi20getv2crowdedness001-p          | Storage Queue Data Contributor                   | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 57 | mi20getv2crowdedness001-p          | Storage File Data SMB Share Elevated Contributor | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 58 | mi20getv2crowdedness001-p          | Storage Blob Data Owner                          | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 59 | mi20getv2crowdedness001-p          | Azure Event Hubs Data Sender                     | 62a81d2f-a2b3-40bc-9689-53c2d8233086 |
| 60 | mi20getv1crowdedness001-p          | Azure Event Hubs Data Receiver                   | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 61 | mi20getv1crowdedness001-p          | Storage Table Data Contributor                   | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 62 | mi20getv1crowdedness001-p          | Storage Queue Data Contributor                   | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 63 | mi20getv1crowdedness001-p          | Storage File Data SMB Share Elevated Contributor | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 64 | mi20getv1crowdedness001-p          | Storage Blob Data Owner                          | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 65 | mi20getv1crowdedness001-p          | Azure Event Hubs Data Sender                     | 00c7a2f3-04dc-47aa-acea-a122bba976df |
| 66 | MI-aaklant-a-akv2k8s               | Key Vault Secrets User                           | c6daf2b3-dec6-42bb-a35b-e59a84250291 |
| 67 | MI-aaklant-a-loki                  | Storage Blob Data Contributor                    | a408dda2-9961-44f1-93c0-690dc09b2832 |
| 68 | MI-aaklant-a-grafana-azure-monitor | Reader                                           | 79de8a80-32e2-46a0-9d23-9e1f0326a3cc |
| 69 | MI-aaklant-a-grafana-azure-monitor | Monitoring Reader                                | 79de8a80-32e2-46a0-9d23-9e1f0326a3cc |
| 70 | MI-aaklant-a-cert-manager          | DNS Zone Contributor                             | 58198776-551d-4426-bdfd-969fec4b0844 |
| 71 | MI-aaklant-a-external-dns-public   | Reader                                           | 401b7b43-66f6-4c44-9b5a-1a6f3890864a |
| 72 | MI-aaklant-a-external-dns-public   | Contributor                                      | 401b7b43-66f6-4c44-9b5a-1a6f3890864a |
| 73 | MI-aaklant-a-agic                  | Contributor                                      | 89728dd5-410d-41c7-a22a-3d9dbedec7c2 |
| 74 | MI-aaklant-a-agic                  | Reader                                           | 89728dd5-410d-41c7-a22a-3d9dbedec7c2 |
| 75 | MI-aaklant-a-agic                  | CustomRole - VNet Subnet Join - NS-Root          | 89728dd5-410d-41c7-a22a-3d9dbedec7c2 |
| 76 | MI-aaklant-a-external-dns-priv     | Reader                                           | 44d532c9-d160-4317-8e1b-cd2de114a038 |
| 77 | MI-aaklant-a-external-dns-priv     | Contributor                                      | 44d532c9-d160-4317-8e1b-cd2de114a038 |
| 78 | MI-aaklant-p-akv2k8s               | Key Vault Secrets User                           | c0e9d65c-31b3-4728-b469-de9157f05394 |
| 79 | MI-aaklant-p-loki                  | Storage Blob Data Contributor                    | 48f68830-6c3f-4e97-8adb-65c7854e563c |
| 80 | MI-aaklant-p-grafana-azure-monitor | Reader                                           | bd8bfe4d-7517-4837-b060-0fd302c05f0c |
| 81 | MI-aaklant-p-grafana-azure-monitor | Monitoring Reader                                | bd8bfe4d-7517-4837-b060-0fd302c05f0c |
| 82 | MI-aaklant-p-cert-manager          | DNS Zone Contributor                             | bdb66110-15a8-4978-b7aa-6fe67db979c4 |
| 83 | MI-aaklant-p-external-dns-priv     | Reader                                           | b4f14afc-953f-4f68-856d-def3de64f9aa |
| 84 | MI-aaklant-p-external-dns-priv     | Contributor                                      | b4f14afc-953f-4f68-856d-def3de64f9aa |
| 85 | MI-aaklant-p-agic                  | Reader                                           | 9eabc778-7469-450d-86ff-f18a143f8798 |
| 86 | MI-aaklant-p-agic                  | Contributor                                      | 9eabc778-7469-450d-86ff-f18a143f8798 |
| 87 | MI-aaklant-p-agic                  | CustomRole - VNet Subnet Join - NS-Root          | 9eabc778-7469-450d-86ff-f18a143f8798 |
| 88 | MI-aaklant-p-external-dns-public   | Reader                                           | 66001afb-94e5-4a6a-b12a-b6e8822ba40f |
| 89 | MI-aaklant-p-external-dns-public   | Contributor                                      | 66001afb-94e5-4a6a-b12a-b6e8822ba40f |
| 90 | mi20rioingestion001-p              | Storage Blob Data Contributor                    | dbfdb25b-584c-4464-8ef5-5cfe2ed325c2 |
| 91 | mi20rioingestion001-p              | Storage File Data SMB Share Elevated Contributor | dbfdb25b-584c-4464-8ef5-5cfe2ed325c2 |
| 92 | mi20containerpull001-t             | AcrPull                                          | 56958443-3933-4b2e-b17d-4ff65035eaac |
| 93 | MI20CNSHW100-A                     | Cost Management Reader                           | 11a630bd-5233-4536-8255-45ba54a9ee7b |

## Omvang

Er zijn maximaal 94 rollen die we over moeten zetten naar onze infra code.
Deze 94 rollen zijn verdeel over de 3 (4?) omgevingen en we zouden dit
omgeving per omgeving moeten proberen uit te rollen. Dus als we het een
beetje gelijk verdeeld is zou het gaan om 30 rollen per omgeving.

## Stappenplan

We hebben nog een wat informatie nodig van ns cloud:

- Hoe kunnen we een upgrade van deze omgeving aanvragen? Gaat dit per
  `resource group` of `subscriptie`?
- Hoe kunnen we ons voorbereiden op een upgrade? Kunnen we de rollen alvast
  aanmaken en toewijzen of moeten we wachten?
- Ik denk dat we `terraform` code kunnen genereren op basis van de
  bovenstaande tabel, of als we iets extra's nodig hebben kunnen we ons
  `bash` script aanpassen om extra velden op te vragen. Als dit gebeurd is
  kunnen we een terraform statement genereren voor de rol en die hangen aan
  de managed identity. Dan hoeven we alleen nog de code te copy/pasten naar
  de juiste locatie en kunnen we de nieuwe rollen uitrollen.