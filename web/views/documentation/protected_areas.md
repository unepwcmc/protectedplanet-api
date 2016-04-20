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
                "name": "Forest Reserve"
            },
            "marine": false
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
                "name": "Forest Reserve"
            },
            "marine": false
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
            "name": "Forest Reserve"
        },
        "marine": false
    }
}
~~~
---

## `GET /v3/protected_areas/search`
Returns a collection of protected areas matching the given attributes. At the moment,
search is possible on the `marine` attribute and on the country ISO.

The accepted parameters are:

~~~
marine (Boolean)
  If set to true, returns all marine protected areas, paginated.
  If set to false, returns all terrestrial protected areas, paginated.
  By default, this is unset: both terrestrial and marine protected areas are returned.

country (String, 3 characters)
  If set, returns all protected areas from the country with the given ISO3, paginated.
  By default, this is unset: protected areas from all countries are returned.

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
                "id": 16,
                "name": "Wildlife Sanctuary"
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
                "id": 2,
                "name": "Ramsar Site, Wetland of International Importance"
            },
            "marine": false
        }
    ]
}
~~~
