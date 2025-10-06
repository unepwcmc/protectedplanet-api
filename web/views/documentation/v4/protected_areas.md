# Protected Areas

## `GET /v4/protected_areas`
Returns all protected areas, paginated. Accepts a `with_geometry` parameter to retrieve a `geojson` representation of the protected areas.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the protected areas.
  Defaults to false.

page (Number)
  Controls the returned page. Defaults to 1.

per_page (Number)
  Controls how many protected areas are returned per page. Defaults to 25.
  For performance reasons, the maximum value is 50.
~~~

Sample response:

~~~
{
    "protected_areas": [
        {
            "name_english": "Yellowstone National Park",
            "name": "Yellowstone National Park",
            "site_id": 555555,
            "site_pid": "555555",
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
            "pame_evaluations": [
                {
                    "id": 29653,
                    "metadata_id": 27,
                    "url": "Not reported",
                    "year": 2018,
                    "methodology": "IMET",
                    "source": {
                        "data_title": "JRC IMET information",
                        "resp_party": "JRC",
                        "year": 2019,
                        "language": "English"
                    }
                }
            ],
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
            "protected_area_parcels": [],
            "links": {
                "protected_planet": "https://protectedplanet.net/555555"
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
            }
        }
    ]
}
~~~

## `GET /v4/protected_areas/search`
Search for a subset of protected areas based on various criteria.

The accepted parameters are:

~~~
country (String)
  Filter by country ISO3 code (3 letters).

marine (Boolean)
  Filter by marine protected areas (true) or terrestrial (false).

is_green_list (Boolean)
  Filter by Green List status. True returns areas with Green List certification.

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
  Controls how many protected areas are returned per page. Defaults to 25.
  For performance reasons, the maximum value is 50.
~~~

**Note**: At least one of the search parameters (country, marine, is_green_list, designation, jurisdiction, governance, iucn_category) must be provided.

Sample request:

~~~
GET /v4/protected_areas/search?country=USA&marine=false&is_green_list=true&per_page=10
~~~

Sample response:

~~~
{
    "protected_areas": [
        {
            "name_english": "Yellowstone National Park",
            "name": "Yellowstone National Park",
            "site_id": 555555,
            "site_pid": "555555",
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
            "pame_evaluations": [
                {
                    "id": 29653,
                    "metadata_id": 27,
                    "url": "Not reported",
                    "year": 2018,
                    "methodology": "IMET",
                    "source": {
                        "data_title": "JRC IMET information",
                        "resp_party": "JRC",
                        "year": 2019,
                        "language": "English"
                    }
                }
            ],
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
            "protected_area_parcels": [],
            "links": {
                "protected_planet": "https://protectedplanet.net/555555"
            },
            "legal_status_updated_at": "01/01/1872"
        }
    ]
}
~~~

## `GET /v4/protected_areas/biopama`
Returns protected areas from ACP (African, Caribbean and Pacific) countries that have PAME evaluations.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry.
  Defaults to false.
~~~

Sample response:

~~~
{
    "protected_areas": [
        {
            "name_english": "Kruger National Park",
            "name": "Kruger National Park",
            "site_id": 123456,
            "site_pid": "123456",
            "international_criteria": "Not Applicable",
            "verif": "State Verified",
            "parent_iso3": "ZAF",
            "gis_marine_area": "0.0",
            "gis_area": "19485.0",
            "site_type": "pa",
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "19485.0",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "governance_subtype": "Not Applicable",
            "owner_type": "Not Reported",
            "ownership_subtype": "Not Applicable",
            "inland_waters": "Not Reported",
            "oecm_assessment": "Not Applicable",
            "countries": [
                {
                    "name": "South Africa",
                    "iso_3": "ZAF",
                    "id": "ZAF"
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
                "id": 124,
                "name": "South African National Parks"
            },
            "governance": {
                "id": 4,
                "name": "Federal or national ministry or agency",
                "governance_type": "Governance by Government"
            },
            "pame_evaluations": [
                {
                    "id": 29653,
                    "metadata_id": 27,
                    "url": "Not reported",
                    "year": 2018,
                    "methodology": "IMET",
                    "source": {
                        "data_title": "JRC IMET information",
                        "resp_party": "JRC",
                        "year": 2019,
                        "language": "English"
                    }
                }
            ],
            "green_list_status": null,
            "sources": [
                {
                    "id": 124,
                    "title": "Protected Areas of South Africa",
                    "responsible_party": "South African National Parks",
                    "year_updated": 2023
                }
            ],
            "realm": {
                "id": 1,
                "name": "Terrestrial"
            },
            "protected_area_parcels": [],
            "links": {
                "protected_planet": "https://protectedplanet.net/123456"
            },
            "legal_status_updated_at": "01/01/1898"
        }
    ]
}
~~~

## `GET /v4/protected_areas/:site_id`
Returns a single protected area by its site_id.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry.
  Defaults to true.
~~~

Sample response:

~~~
{
    "protected_area": {
        "name_english": "Yellowstone National Park",
        "name": "Yellowstone National Park",
        "site_id": 555555,
        "site_pid": "555555",
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
            "name": "Federal or national ministry or agency",
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
        "pame_evaluations": [
                {
                    "id": 29653,
                    "metadata_id": 27,
                    "url": "Not reported",
                    "year": 2018,
                    "methodology": "IMET",
                    "source": {
                        "data_title": "JRC IMET information",
                        "resp_party": "JRC",
                        "year": 2019,
                        "language": "English"
                    }
                }
            ],
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
        "protected_area_parcels": [],
        "links": {
            "protected_planet": "https://protectedplanet.net/555555"
        },
        "legal_status_updated_at": "01/01/1872"
    }
}
~~~
