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
            "links": {
                "protected_planet": "http://protectedplanet.net/40366"
            },
            "countries": [
                {
                    "name": "Uganda",
                    "iso_3": "UGA",
                    "id": "UGA"
                }
            ],
            "sublocations": {},
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 3,
                "name": "Forest Reserve",
                jurisdiction: {
                  id: 1,
                  name: "National"
                }
            },
            "no_take_status": {
              id: 11851,
              name: "Not Applicable",
              area: "0.0"
            }
            "marine": false,
            "reported_area": "0.3933",
            "reported_marine_area": "0.0",
            "legal_status_updated_at": "01/01/1998",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "governance": {
              "id": 1,
              "governance_type": "Governance by Government"
            },
            "owner_type": "Not Reported",
            "pame_evaluations": [
              {
                "id": 1,
                "method": "METT",
                "year": 2018
              }
            ]
        },
        {
            "id": 64700,
            "name": "Otzi",
            "original_name": "Otzi (East and West)",
            "wdpa_id": 64700,
            "links": {
                "protected_planet": "http://protectedplanet.net/64700"
            },
            "countries": [
                {
                    "name": "Uganda",
                    "iso_3": "UGA",
                    "id": "UGA"
                }
            ],
            "sublocations": {},
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 3,
                "name": "Forest Reserve",
                jurisdiction: {
                  id: 1,
                  name: "National"
                }
            },
            "no_take_status": {
              "id": 13537,
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
            "marine": false,
            "reported_area": "5.1867",
            "reported_marine_area": "0.0",
            "legal_status_updated_at": "01/01/1948",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "governance": {
              "id": 1,
              "governance_type": "Governance by Government"
            },
            "owner_type": "Not Reported"
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
        "links": {
            "protected_planet": "http://protectedplanet.net/40366"
        },
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
                        [ 29.785, -0.692 ],
                        [ 29.782, -0.687 ],
                        [ 29.785, -0.683 ],
                        [ 29.789, -0.688 ],
                        [ 29.785, -0.692 ]
                    ]
                ]
            }
        },
        "countries": [
            {
                "name": "Uganda",
                "iso_3": "UGA",
                "id": "UGA"
            }
        ],
        "sublocations": {},
        "iucn_category": {
            "id": 8,
            "name": "Not Reported"
        },
        "designation": {
            "id": 3,
            "name": "Forest Reserve",
            jurisdiction: {
              id: 1,
              name: "National"
            }
        },
        "no_take_status": {
          "id": 11874,
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
        "marine": false,
        "reported_area": "106.25",
        "reported_marine_area": "0.0",
        "legal_status_updated_at": "01/01/1998",
        "management_plan": "Not Reported",
        "is_green_list": false,
        "governance": {
          "id": 1,
          "governance_type": "Governance by Government"
        },
        "owner_type": "Not Reported"
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
            "links": {
                "protected_planet": "http://protectedplanet.net/6722"
            },
            "countries": [
                {
                    "name": "Pakistan",
                    "iso_3": "PAK",
                    "id": "PAK"
                }
            ],
            "sublocations": {},
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 3,
                "name": "Forest Reserve",
                jurisdiction: {
                  id: 1,
                  name: "National"
                }
            },
            "marine": false
        },
        {
            "id": 166899,
            "name": "Kyliiske Mouth",
            "original_name": "Kyliiske Mouth",
            "wdpa_id": 166899,
            "links": {
                "protected_planet": "http://protectedplanet.net/166899"
            },
            "countries": [
                {
                    "name": "Ukraine",
                    "iso_3": "UKR",
                    "id": "UKR"
                }
            ],
            "sublocations": {},
            "iucn_category": {
                "id": 8,
                "name": "Not Reported"
            },
            "designation": {
                "id": 3,
                "name": "Forest Reserve",
                jurisdiction: {
                  id: 1,
                  name: "National"
                }
            },
            "no_take_status": {
              "id": 2634,
              "name": "Not Applicable"
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
            "marine": false,
            "reported_area": "230.46",
            "reported_marine_area": "46.66",
            "legal_status_updated_at": "01/01/1977",
            "management_plan": "Not Reported",
            "is_green_list": false,
            "governance": {
              "id": 2,
              "governance_type": "Not Reported"
            },
            "owner_type: "Not Reported"
        }
    ]
}
~~~
