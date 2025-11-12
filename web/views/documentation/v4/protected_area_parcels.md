# Protected Area Parcels

Protected Area Parcels represent individual parcels or sub-areas within protected areas. This is a new feature in API v4 that allows for more granular access to protected area data.

**Important Notes:**

- The primary protected area data represents the first parcel
- Each parcel object contains similar structure as the main protected area object
- The `protected_area_parcels` array includes all parcels (including the first one) for complete coverage

## `GET /v4/protected_area_parcels`
Returns all protected area parcels, paginated.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the parcels.
  Defaults to false.

page (Number)
  Controls the returned page. Defaults to 1.

per_page (Number)
  Controls how many parcels are returned per page. Defaults to 25.
  For performance reasons, the maximum value is 50.
~~~

Sample response:

~~~
{
    "protected_area_parcels": [
        {
            "name_english": "Yellowstone National Park - Main Area",
            "name": "Yellowstone National Park - Main Area",
            "site_id": 555555,
            "site_pid": "555555_1",
            "international_criteria": "World Heritage Site",
            "verif": "State Verified",
            "parent_iso3": "USA",
            "gis_marine_area": "0.0",
            "gis_area": "8983.18",
            "site_type": "pa",
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "8983.18",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "supplementary_info": "Not Applicable",
            "conservation_objectives": "not applicable",
            "green_list_url": null,
            "governance_subtype": "Not Applicable",
            "owner_type": "Not Reported",
            "ownership_subtype": "Not Applicable",
            "inland_waters": "Not Reported",
            "oecm_assessment": "Not Applicable",
            "countries": [
                {
                    "name": "United States",
                    "iso_3": "USA",
                    "id": "USA"
                }
            ],
            "iucn_category": {
                "id": 3,
                "name": "II"
            },
            "designation": {
                "id": 4,
                "name": "National Park",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                }
            },
            "no_take_status": {
                "id": 456,
                "name": "Not Applicable",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 123,
                "name": "National Park Service"
            },
            "governance": {
                "id": 4,
                "governance_type": "Governance by Government"
            },
            "sources": [
                {
                    "id": 123,
                    "title": "Protected Areas of United States",
                    "responsible_party": "National Park Service",
                    "year_updated": 2023
                }
            ],
            "realm": {
                "id": 1,
                "name": "Terrestrial"
            },
            "green_list_status": {
                "id": 1,
                "status": "Listed",
                "expiry_date": null
            },
            "links": {
                "protected_planet": "https://protectedplanet.net/555555"
            },
            "legal_status_updated_at": "01/01/1872"
        }
    ]
}
~~~

## `GET /v4/protected_area_parcels/search`
Search for a subset of protected area parcels based on various criteria.

The accepted parameters are:

~~~
country (String)
  Filter by country ISO3 code (3 letters).

marine (Boolean)
  Filter by marine parcels (true) or terrestrial (false).

designation (Integer)
  Filter by designation ID.

jurisdiction (Integer)
  Filter by jurisdiction ID.

governance (Integer)
  Filter by governance ID.

iucn_category (Integer)
  Filter by IUCN category ID.

with_geometry (Boolean)
  If set, returns the geojson representation of the geometry.
  Defaults to false.

page (Number)
  Controls the returned page. Defaults to 1.

per_page (Number)
  Controls how many parcels are returned per page. Defaults to 25.
  For performance reasons, the maximum value is 50.
~~~

**Note**: At least one of the search parameters (country, marine, designation, jurisdiction, governance, iucn_category) must be provided.

Sample request:

~~~
GET /v4/protected_area_parcels/search?country=USA&marine=false&per_page=10
~~~

Sample response:

~~~
{
    "protected_area_parcels": [
        {
            "name_english": "Yellowstone National Park - Main Area",
            "name": "Yellowstone National Park - Main Area",
            "site_id": 555555,
            "site_pid": "555555_1",
            "international_criteria": "World Heritage Site",
            "verif": "State Verified",
            "parent_iso3": "USA",
            "gis_marine_area": "0.0",
            "gis_area": "8983.18",
            "site_type": "pa",
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "8983.18",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "supplementary_info": "Not Applicable",
            "conservation_objectives": "not applicable",
            "green_list_url": null,
            "governance_subtype": "Not Applicable",
            "owner_type": "Not Reported",
            "ownership_subtype": "Not Applicable",
            "inland_waters": "Not Reported",
            "oecm_assessment": "Not Applicable",
            "countries": [
                {
                    "name": "United States",
                    "iso_3": "USA",
                    "id": "USA"
                }
            ],
            "iucn_category": {
                "id": 3,
                "name": "II"
            },
            "designation": {
                "id": 4,
                "name": "National Park",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                }
            },
            "no_take_status": {
                "id": 456,
                "name": "Not Applicable",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 123,
                "name": "National Park Service"
            },
            "governance": {
                "id": 4,
                "governance_type": "Governance by Government"
            },
            "green_list_status": {
                "id": 1,
                "status": "Listed",
                "expiry_date": null
            },
            "sources": [
                {
                    "id": 123,
                    "title": "Protected Areas of United States",
                    "responsible_party": "National Park Service",
                    "year_updated": 2023
                }
            ],
            "realm": {
                "id": 1,
                "name": "Terrestrial"
            },
            "links": {
                "protected_planet": "https://protectedplanet.net/555555"
            },
            "legal_status_updated_at": "01/01/1872"
        }
    ]
}
~~~

## `GET /v4/protected_area_parcels/:site_id`
Returns all parcels for a protected area by its site_id.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry.
  Defaults to true.
~~~

Sample response:

~~~
{
    "protected_area_parcels": [
        {
            "name_english": "Yellowstone National Park - Main Area",
            "name": "Yellowstone National Park - Main Area",
            "site_id": 555555,
            "site_pid": "555555_1",
            "international_criteria": "World Heritage Site",
            "verif": "State Verified",
            "parent_iso3": "USA",
            "gis_marine_area": "0.0",
            "gis_area": "8983.18",
            "site_type": "pa",
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "8983.18",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "supplementary_info": "Not Applicable",
            "conservation_objectives": "not applicable",
            "green_list_url": null,
            "governance_subtype": "Not Applicable",
            "owner_type": "Not Reported",
            "ownership_subtype": "Not Applicable",
            "inland_waters": "Not Reported",
            "oecm_assessment": "Not Applicable",
            "countries": [
                {
                    "name": "United States",
                    "iso_3": "USA",
                    "id": "USA"
                }
            ],
            "iucn_category": {
                "id": 3,
                "name": "II"
            },
            "designation": {
                "id": 4,
                "name": "National Park",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                }
            },
            "no_take_status": {
                "id": 456,
                "name": "Not Applicable",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 123,
                "name": "National Park Service"
            },
            "governance": {
                "id": 4,
                "governance_type": "Governance by Government"
            },
            "sources": [
                {
                    "id": 123,
                    "title": "Protected Areas of United States",
                    "responsible_party": "National Park Service",
                    "year_updated": 2023
                }
            ],
            "realm": {
                "id": 1,
                "name": "Terrestrial"
            },
            "green_list_status": {
                "id": 1,
                "status": "Listed",
                "expiry_date": null
            },
            "legal_status_updated_at": "01/01/1872",
            "geojson": {
                "type": "Feature",
                "properties": {
                    "fill-opacity": 0.7,
                    "stroke-width": 0.05,
                    "stroke": "#40541b",
                    "fill": "#83ad35",
                    "marker-color": "#2B3146"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [...]
                }
            },
            "links": {
                "protected_planet": "https://protectedplanet.net/555555"
            }
        }
    ]
}
~~~

## `GET /v4/protected_area_parcels/:site_id/:site_pid`
Returns a specific parcel by its site_id and site_pid combination.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry.
  Defaults to true.
~~~

Sample response:

~~~
{
    "protected_area_parcel": {
        "name_english": "Yellowstone National Park - Main Area",
        "name": "Yellowstone National Park - Main Area",
        "site_id": 555555,
        "site_pid": "555555_1",
        "international_criteria": "World Heritage Site",
        "verif": "State Verified",
        "parent_iso3": "USA",
        "gis_marine_area": "0.0",
        "gis_area": "8983.18",
        "site_type": "pa",
        "marine": false,
        "reported_marine_area": "0.0",
        "reported_area": "8983.18",
        "management_plan": "Not Reported",
        "is_green_list": false,
        "is_oecm": false,
        "supplementary_info": "Not Applicable",
        "conservation_objectives": "not applicable",
        "green_list_url": null,
        "governance_subtype": "Not Applicable",
        "owner_type": "Not Reported",
        "ownership_subtype": "Not Applicable",
        "inland_waters": "Not Reported",
        "oecm_assessment": "Not Applicable",
        "geojson": {
            "type": "Feature",
            "properties": {
                "fill-opacity": 0.7,
                "stroke-width": 0.05,
                "stroke": "#40541b",
                "fill": "#83ad35",
                "marker-color": "#2B3146"
            },
            "geometry": {
                "type": "Polygon",
                "coordinates": [...]
            }
        },
        "countries": [
            {
                "name": "United States",
                "iso_3": "USA",
                "id": "USA"
            }
        ],
        "designation": {
            "id": 4,
            "name": "National Park",
            "jurisdiction": {
                "id": 1,
                "name": "National"
            }
        },
        "iucn_category": {
            "id": 3,
            "name": "II"
        },
        "governance": {
            "id": 4,
            "governance_type": "Governance by Government"
        },
        "legal_status": {
            "id": 1,
            "name": "Designated"
        },
        "management_authority": {
            "id": 123,
            "name": "National Park Service"
        },
        "no_take_status": {
            "id": 456,
            "name": "Not Applicable",
            "area": "0.0"
        },
        "green_list_status": {
            "id": 1,
            "status": "Listed",
            "expiry_date": null
        },
        "sources": [
            {
                "id": 123,
                "title": "Protected Areas of United States",
                "responsible_party": "National Park Service",
                "year_updated": 2023
            }
        ],
        "realm": {
            "id": 1,
            "name": "Terrestrial"
        },
        "links": {
            "protected_planet": "https://protectedplanet.net/555555"
        },
        "legal_status_updated_at": "01/01/1872"
    }
}
~~~
