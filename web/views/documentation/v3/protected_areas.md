# Protected Areas

## `GET /v3/protected_areas`
Returns all protected areas, paginated. Accepts a `with_geometry` parameter, to
retrieve a `geojson` representation of the protected area.

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
            "id": 40366,
            "name": "Kaniabizo",
            "original_name": "Kaniabizo",
            "wdpa_id": 40366,
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
                    "coordinates": [
                        [
                            [
                                29.785,
                                -0.692
                            ],
                            [
                                29.782,
                                -0.687
                            ],
                            [
                                29.785,
                                -0.683
                            ],
                            [
                                29.789,
                                -0.688
                            ],
                            [
                                29.785,
                                -0.692
                            ]
                        ]
                    ]
                }
            },
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "0.3933",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "supplementary_info": "Not Applicable",
            "conservation_objectives": "Not Applicable",
            "green_list_url": null,
            "owner_type": "Not Reported",
            "countries": [
                {
                    "name": "Uganda",
                    "iso_3": "UGA",
                    "id": "UGA"
                }
            ],
            "sub_locations": [], // This will be always empty list in v3 and will be removed in v4
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 13,
                "name": "Forest Reserve",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                }
            },
            "no_take_status": {
                "id": 11293,
                "name": "Not Applicable",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 6,
                "name": "Not Reported"
            },
            "governance": {
                "id": 1,
                "governance_type": "Governance by Government"
            },
            "pame_evaluations": [],
            "green_list_status": null,
            "links": {
                "protected_planet": "https://protectedplanet.net/40366"
            },
            "legal_status_updated_at": "01/01/1998"
        },
        {
            "id": 555547509,
            "name": "Al-Hoceima National Park",
            "original_name": "Al-Hoceima National Park",
            "wdpa_id": 555547509,
            "geojson": {
                "type": "Feature",
                "properties": {
                    "fill-opacity": 0.7,
                    "stroke-width": 0.05,
                    "stroke": "#2E5387",
                    "fill": "#3E7BB6",
                    "marker-color": "#2B3146"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                        [
                            [
                                -3.965,
                                35.245
                            ],
                            [
                                -3.963,
                                35.242
                            ],
                            [
                                -3.972,
                                35.235
                            ],
                            [
                                -3.97,
                                35.231
                            ],
                            [
                                -3.984,
                                35.221
                            ],
                            [
                                -3.975,
                                35.204
                            ],
                            [
                                -3.981,
                                35.199
                            ],
                            [
                                -3.979,
                                35.195
                            ],
                            [
                                -3.987,
                                35.194
                            ],
                            [
                                -3.995,
                                35.184
                            ],
                            [
                                -3.992,
                                35.168
                            ],
                            [
                                -3.976,
                                35.156
                            ],
                            [
                                -3.993,
                                35.141
                            ],
                            [
                                -4.045,
                                35.134
                            ],
                            [
                                -4.134,
                                35.14
                            ],
                            [
                                -4.17,
                                35.122
                            ],
                            [
                                -4.188,
                                35.107
                            ],
                            [
                                -4.202,
                                35.104
                            ],
                            [
                                -4.215,
                                35.112
                            ],
                            [
                                -4.247,
                                35.112
                            ],
                            [
                                -4.278,
                                35.122
                            ],
                            [
                                -4.337,
                                35.116
                            ],
                            [
                                -4.353,
                                35.131
                            ],
                            [
                                -4.372,
                                35.132
                            ],
                            [
                                -4.377,
                                35.138
                            ],
                            [
                                -4.375,
                                35.148
                            ],
                            [
                                -4.379,
                                35.154
                            ],
                            [
                                -4.369,
                                35.203
                            ],
                            [
                                -4.255,
                                35.237
                            ],
                            [
                                -3.993,
                                35.286
                            ],
                            [
                                -3.965,
                                35.245
                            ]
                        ]
                    ]
                }
            },
            "marine": true,
            "reported_marine_area": "196.0",
            "reported_area": "484.6",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "is_oecm": false,
            "supplementary_info": "Not Applicable",
            "conservation_objectives": "Not Applicable",
            "green_list_url": null,
            "owner_type": "Not Reported",
            "countries": [
                {
                    "name": "Morocco",
                    "iso_3": "MAR",
                    "id": "MAR"
                }
            ],
            "sub_locations": [], // This will be always empty list in v3 and will be removed in v4
            "iucn_category": {
                "id": 10,
                "name": "Not Assigned"
            },
            "designation": {
                "id": 526,
                "name": "Specially Protected Areas of Mediterranean Importance (Barcelona Convention)",
                "jurisdiction": {
                    "id": 3,
                    "name": "Regional"
                }
            },
            "no_take_status": {
                "id": 148453,
                "name": "Not Reported",
                "area": "0.0"
            },
            "legal_status": {
                "id": 6,
                "name": "Adopted"
            },
            "management_authority": {
                "id": 6,
                "name": "Not Reported"
            },
            "governance": {
                "id": 1,
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
            "links": {
                "protected_planet": "https://protectedplanet.net/555547509"
            },
            "legal_status_updated_at": "01/01/2009"
        }
    ]
}
~~~

---

## `GET /v3/protected_areas/:wdpa_id`
Returns the protected area with WDPA ID `:wdpa_id`. A `geojson` representation
of the geometry is also returned.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the protected areas.
  Defaults to true.
~~~

Sample response:

~~~
{
    "protected_area": {
        "id": 40366,
        "name": "Kaniabizo",
        "original_name": "Kaniabizo",
        "wdpa_id": 40366,
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
                "coordinates": [
                    [
                        [
                            29.785,
                            -0.692
                        ],
                        [
                            29.782,
                            -0.687
                        ],
                        [
                            29.785,
                            -0.683
                        ],
                        [
                            29.789,
                            -0.688
                        ],
                        [
                            29.785,
                            -0.692
                        ]
                    ]
                ]
            }
        },
        "marine": false,
        "reported_marine_area": "0.0",
        "reported_area": "0.3933",
        "management_plan": "Not Reported",
        "is_green_list": false,
        "is_oecm": false,
        "supplementary_info": "Not Applicable",
        "conservation_objectives": "Not Applicable",
        "green_list_url": null,
        "owner_type": "Not Reported",
        "countries": [
            {
                "name": "Uganda",
                "iso_3": "UGA",
                "id": "UGA"
            }
        ],
        "sub_locations": [], // This will be always empty list in v3 and will be removed in v4
        "iucn_category": {
            "id": 8,
            "name": "Not Reported"
        },
        "designation": {
            "id": 13,
            "name": "Forest Reserve",
            "jurisdiction": {
                "id": 1,
                "name": "National"
            }
        },
        "no_take_status": {
            "id": 11293,
            "name": "Not Applicable",
            "area": "0.0"
        },
        "legal_status": {
            "id": 1,
            "name": "Designated"
        },
        "management_authority": {
            "id": 6,
            "name": "Not Reported"
        },
        "governance": {
            "id": 1,
            "governance_type": "Governance by Government"
        },
        "pame_evaluations": [],
        "green_list_status": null,
        "links": {
            "protected_planet": "https://protectedplanet.net/40366"
        },
        "legal_status_updated_at": "01/01/1998"
    }
}
~~~
---

## `GET /v3/protected_areas/search`
Returns a collection of protected areas matching the given attributes. At the moment,
search is possible on the `marine` attribute and on the country ISO.

The accepted parameters are:

~~~
is_green_list (Boolean)
  If set to true, returns all green listed protected areas, paginated.
  If set to false, returns all non-green listed protected areas, paginated.
  By default, this is unset: both green listed and non-green listed protected areas are returned.

marine (Boolean)
  If set to true, returns all marine protected areas, paginated.
  If set to false, returns all terrestrial protected areas, paginated.
  By default, this is unset: both terrestrial and marine protected areas are returned.

country (String, 3 characters)
  If set, returns all protected areas from the country with the given ISO3, paginated.
  By default, this is unset: protected areas from all countries are returned.

designation (Integer)
  If set, returns all protected areas designated with the given `id`, paginated.
  By default, this is unset: protected areas with all designations are returned.

jurisdiction (Integer)
  If set, returns all protected areas with the given jurisdiciton `id`, paginated.
  By default, this is unset: protected areas with all jurisdictions are returned.

governance (Integer)
  If set, returns all protected areas with the given governance `id`, paginated.
  By default, this is unset: protected areas with all governances are returned.

iucn_category (Integer)
  If set, returns all protected areas with the given IUCN category `id`, paginated.
  By default, this is unset: protected areas with all IUCN categories are returned.

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
            "id": 6722,
            "name": "Keti Bunder South",
            "original_name": "Keti Bunder South",
            "wdpa_id": 6722,
            "geojson": {
                "type": "Feature",
                "properties": {
                    "fill-opacity": 0.7,
                    "stroke-width": 0.05,
                    "stroke": "#2E5387",
                    "fill": "#3E7BB6",
                    "marker-color": "#2B3146"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                        [
                            [
                                67.917,
                                24.054
                            ],
                            [
                                67.937,
                                24.053
                            ],
                            [
                                67.989,
                                24.036
                            ],
                            [
                                68.008,
                                24.044
                            ],
                            [
                                68.024,
                                24.035
                            ],
                            [
                                68.059,
                                24.001
                            ],
                            [
                                68.08,
                                23.994
                            ],
                            [
                                68.115,
                                23.998
                            ],
                            [
                                68.134,
                                23.99
                            ],
                            [
                                68.158,
                                23.947
                            ],
                            [
                                68.161,
                                23.92
                            ],
                            [
                                68.161,
                                23.906
                            ],
                            [
                                68.147,
                                23.866
                            ],
                            [
                                68.141,
                                23.875
                            ],
                            [
                                68.15,
                                23.903
                            ],
                            [
                                68.142,
                                23.91
                            ],
                            [
                                68.144,
                                23.893
                            ],
                            [
                                68.133,
                                23.868
                            ],
                            [
                                68.141,
                                23.843
                            ],
                            [
                                68.121,
                                23.845
                            ],
                            [
                                68.108,
                                23.858
                            ],
                            [
                                68.11,
                                23.88
                            ],
                            [
                                68.1,
                                23.869
                            ],
                            [
                                68.105,
                                23.846
                            ],
                            [
                                68.086,
                                23.837
                            ],
                            [
                                68.041,
                                23.832
                            ],
                            [
                                68.041,
                                23.792
                            ],
                            [
                                67.999,
                                23.789
                            ],
                            [
                                67.986,
                                23.794
                            ],
                            [
                                67.971,
                                23.812
                            ],
                            [
                                67.957,
                                23.817
                            ],
                            [
                                67.951,
                                23.815
                            ],
                            [
                                67.936,
                                23.84
                            ],
                            [
                                67.921,
                                23.853
                            ],
                            [
                                67.919,
                                23.846
                            ],
                            [
                                67.928,
                                23.831
                            ],
                            [
                                67.871,
                                23.861
                            ],
                            [
                                67.838,
                                23.863
                            ],
                            [
                                67.835,
                                23.823
                            ],
                            [
                                67.82,
                                23.814
                            ],
                            [
                                67.798,
                                23.816
                            ],
                            [
                                67.736,
                                23.84
                            ],
                            [
                                67.749,
                                23.974
                            ],
                            [
                                67.758,
                                23.996
                            ],
                            [
                                67.775,
                                24.011
                            ],
                            [
                                67.813,
                                24.105
                            ],
                            [
                                67.831,
                                24.137
                            ],
                            [
                                67.853,
                                24.139
                            ],
                            [
                                67.88,
                                24.109
                            ],
                            [
                                67.906,
                                24.057
                            ],
                            [
                                67.917,
                                24.054
                            ]
                        ]
                    ]
                }
            },
            "marine": true,
            "reported_marine_area": "46.66",
            "reported_area": "230.46",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "owner_type": "Not Reported",
            "countries": [
                {
                    "name": "Pakistan",
                    "iso_3": "PAK",
                    "id": "PAK"
                }
            ],
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 41,
                "name": "Wildlife Sanctuary",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                }
            },
            "no_take_status": {
                "id": 2700,
                "name": "Not Reported",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 6,
                "name": "Not Reported"
            },
            "governance": {
                "id": 2,
                "governance_type": "Not Reported"
            },
            "pame_evaluations": [],
            "links": {
                "protected_planet": "https://protectedplanet.net/6722"
            },
            "legal_status_updated_at": "01/01/1977"
        },
        {
            "id": 166899,
            "name": "Kyliiske Mouth",
            "original_name": "Kyliiske Mouth",
            "wdpa_id": 166899,
            "geojson": {
                "type": "Feature",
                "properties": {
                    "fill-opacity": 0.7,
                    "stroke-width": 0.05,
                    "stroke": "#2E5387",
                    "fill": "#3E7BB6",
                    "marker-color": "#2B3146"
                },
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [
                        [
                            [
                                29.542,
                                45.541
                            ],
                            [
                                29.552,
                                45.532
                            ],
                            [
                                29.595,
                                45.557
                            ],
                            [
                                29.624,
                                45.538
                            ],
                            [
                                29.738,
                                45.495
                            ],
                            [
                                29.745,
                                45.426
                            ],
                            [
                                29.775,
                                45.308
                            ],
                            [
                                29.755,
                                45.28
                            ],
                            [
                                29.749,
                                45.246
                            ],
                            [
                                29.714,
                                45.25
                            ],
                            [
                                29.676,
                                45.218
                            ],
                            [
                                29.661,
                                45.255
                            ],
                            [
                                29.679,
                                45.29
                            ],
                            [
                                29.665,
                                45.327
                            ],
                            [
                                29.612,
                                45.375
                            ],
                            [
                                29.588,
                                45.413
                            ],
                            [
                                29.579,
                                45.45
                            ],
                            [
                                29.51,
                                45.502
                            ],
                            [
                                29.489,
                                45.543
                            ],
                            [
                                29.517,
                                45.564
                            ],
                            [
                                29.542,
                                45.541
                            ]
                        ]
                    ]
                }
            },
            "marine": true,
            "reported_marine_area": "0.0",
            "reported_area": "328.0",
            "management_plan": "Management plan is not implented but is available",
            "is_green_list": false,
            "owner_type": "Not Reported",
            "countries": [
                {
                    "name": "Ukraine",
                    "iso_3": "UKR",
                    "id": "UKR"
                }
            ],
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 256,
                "name": "Ramsar Site, Wetland of International Importance",
                "jurisdiction": {
                    "id": 2,
                    "name": "International"
                }
            },
            "no_take_status": {
                "id": 41349,
                "name": "Not Reported",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 6,
                "name": "Not Reported"
            },
            "governance": {
                "id": 2,
                "governance_type": "Not Reported"
            },
            "pame_evaluations": [],
            "links": {
                "protected_planet": "https://protectedplanet.net/166899"
            },
            "legal_status_updated_at": "01/01/1976"
        }

    ]
}
~~~
---

## `GET /v3/protected_areas/biopama`
Returns all protected areas within the BIOPAMA ACP countries which have PAME Evaluations.
Accepts a `with_geometry` parameter.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the protected areas.
  Defaults to false.
~~~

Sample response:

~~~
{
    "protected_areas": [
        {
            "id": 24,
            "name": "Inagua National Park",
            "original_name": "Inagua National Park",
            "wdpa_id": 24,
            "marine": false,
            "reported_marine_area": "0.0",
            "reported_area": "773.430147925",
            "management_plan": "https://www.bnt.bs//_m1731/The-National-Parks-of-The-Bahamas/Inagua-National-Park",
            "is_green_list": false,
            "owner_type": "Not Reported",
            "countries": [
                {
                    "name": "Bahamas",
                    "iso_3": "BHS",
                    "id": "BHS"
                }
            ],
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
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
                "id": 21,
                "name": "Not Applicable",
                "area": "0.0"
            },
            "legal_status": {
                "id": 1,
                "name": "Designated"
            },
            "management_authority": {
                "id": 4,
                "name": "Bahamas National Trust"
            },
            "governance": {
                "id": 2,
                "governance_type": "Not Reported"
            },
            "pame_evaluations": [
                {
                    "id": 9829,
                    "metadata_id": 25,
                    "url": "Not reported",
                    "year": 2018,
                    "methodology": "METT-RAPPAM",
                    "source": {
                        "data_title": "The Bahamas management effectiveness information",
                        "resp_party": "Department of Marine Resources",
                        "year": 2018,
                        "language": "English"
                    }
                }
            ],
            "links": {
                "protected_planet": "https://protectedplanet.net/24"
            },
            "legal_status_updated_at": "01/01/1997"
        },
        {
            "id": 180,
            "name": "Cotubanamá (Del Este)",
            "original_name": "Cotubanamá (Del Este)"
        }
    ]
}
~~~