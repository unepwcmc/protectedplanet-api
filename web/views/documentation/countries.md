# Countries

## `GET /v3/countries`
Returns all countries, paginated. Accepts a `with_geometry` parameter, to
retrieve a `geojson` representation of the countries.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the countries.
  Defaults to false.

page (Number)
  Controls the returned page. Defaults to 1.

per_page (Number)
  Controls how many countries are returned per page. Defaults to 25.
  For performance reasons, the maximum value is 50.
~~~

Sample response:

~~~
{
    "countries": [
        {
            "name": "Philippines",
            "iso_3": "PHL",
            "id": "PHL",
            "links": {
                "protected_planet": "http://protectedplanet.net/country/PH"
            },
            "pas_count": 558,
            "pa_national_count": 547,
            "pa_regional_count": 0,
            "pa_international_count": 11,
            "statistics": {
                "pa_area": 51844.34889409,
                "percentage_cover_pas": null,
                "eez_area": null,
                "ts_area": 298762.86,
                "pa_land_area": 32739.84,
                "pa_marine_area": 19104.50889409,
                "percentage_pa_land_cover": 10.96,
                "percentage_pa_eez_cover": null,
                "percentage_pa_ts_cover": null,
                "land_area": 298762.86,
                "percentage_pa_cover": 12,
                "pa_eez_area": null,
                "pa_ts_area": null,
                "percentage_pa_marine_cover": 1.04,
                "marine_area": 1829405.068391,
                "polygons_count": 16,
                "points_count": 16
            },
            "pame_statistics": {
                "assessments": 39,
                "assessed_pas": 18,
                "average_score": 0.496317020061398,
                "total_area_assessed": 9884.5502680511,
                "percentage_area_assessed": 13.1224063174949
            },
            "region": {
                "name": "Asia",
                "iso": "AS"
            },
            "designations": [
                {
                    "id": 4,
                    "name": "National Park",
                    "jurisdiction": {
                        "id": 1,
                        "name": "National"
                    },
                    "pas_count": 2
                },
                {
                    "id": 7,
                    "name": "Protected Landscape",
                    "jurisdiction": {
                        "id": 1,
                        "name": "National"
                    },
                    "pas_count": 1
                }
            ],
            "iucn_categories": [
                {
                    "id": 3,
                    "name": "II",
                    "pas_count": 2,
                    "pas_percentage": 6.25
                },
                {
                    "id": 5,
                    "name": "IV",
                    "pas_count": 1,
                    "pas_percentage": 3.13
                }
            ],
            "governances": [
                {
                    "id": 4,
                    "name": "Federal or national ministry or agency",
                    "pas_count": 1,
                    "pas_percentage": 3.13
                },
                {
                    "id": 7,
                    "name": "Not Reported",
                    "pas_count": 22,
                    "pas_percentage": 68.75
                }
            ]
        },
        {
            "name": "Switzerland",
            "iso_3": "CHE",
            "id": "CHE",
            "links": {
                "protected_planet": "http://protectedplanet.net/country/CH"
            },
            "pas_count": 558,
            "pa_national_count": 547,
            "pa_regional_count": 0,
            "pa_international_count": 11,
            "statistics": {
                "pa_area": 4104.71,
                "percentage_cover_pas": null,
                "eez_area": null,
                "ts_area": 41355.27,
                "pa_land_area": 4104.71,
                "pa_marine_area": null,
                "percentage_pa_land_cover": 9.93,
                "percentage_pa_eez_cover": null,
                "percentage_pa_ts_cover": null,
                "land_area": 41355.27,
                "percentage_pa_cover": 9.93,
                "pa_eez_area": null,
                "pa_ts_area": null,
                "percentage_pa_marine_cover": null,
                "marine_area": null,
                "polygons_count": 0,
                "points_count": 2
            },
            "pame_statistics": {
                "assessments": 20,
                "assessed_pas": 14,
                "average_score": 0.780597953216374,
                "total_area_assessed": 1266.50166158781,
                "percentage_area_assessed": 21.5681993197221
            },
            "region": {
                "name": "Europe",
                "iso": "EU"
            },
            "designations": [
                {
                    "id": 1,
                    "name": "UNESCO-MAB Biosphere Reserve",
                    "jurisdiction": {
                        "id": 2,
                        "name": "International"
                    },
                    "pas_count": 2
                }
            ],
            "iucn_categories": [
                {
                    "id": 8,
                    "name": "Not Reported",
                    "pas_count": 2,
                    "pas_percentage": 100
                }
            ],
            "governances": [
                {
                    "id": 7,
                    "name": "Not Reported",
                    "pas_count": 2,
                    "pas_percentage": 100
                }
            ]
        }
    ]
}
~~~

---

## `GET /v3/countries/:iso_3`
Returns the country with ISO3 `:iso_3`. A `geojson` representation
of the geometry is also returned.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the country.
  Defaults to true.
~~~

Sample response:

~~~
{
    "country": {
        "name": "United States of America",
        "iso_3": "USA",
        "id": "USA",
        "links": {
            "protected_planet": "http://protectedplanet.net/country/US"
        },
        "pas_count": 558,
        "pa_national_count": 547,
        "pa_regional_count": 0,
        "pa_international_count": 11,
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
                        [ -180, 19 ],
                        [ -180, 71 ],
                        [ -50, 71 ],
                        [ -50, 19 ],
                        [ -180, 19 ]
                    ]
                ]
            }
        },
        "statistics": {
            "pa_area": 2565883.979754,
            "percentage_cover_pas": null,
            "eez_area": null,
            "ts_area": 9336666.44,
            "pa_land_area": 1294475.95,
            "pa_marine_area": 1271408.029754,
            "percentage_pa_land_cover": 13.86,
            "percentage_pa_eez_cover": null,
            "percentage_pa_ts_cover": null,
            "land_area": 9336666.44,
            "percentage_pa_cover": 26.32,
            "pa_eez_area": null,
            "pa_ts_area": null,
            "percentage_pa_marine_cover": 12.46,
            "marine_area": 10201208.33913,
            "polygons_count": 1,
            "points_count": 37
        },
        "pame_statistics": {
            "assessments": 101,
            "assessed_pas": 79,
            "average_score": 0.621947365828616,
            "total_area_assessed": 517805.948887391,
            "percentage_area_assessed": 18.834276817517
        },
        "region": {
            "name": "North America",
            "iso": "NA"
        },
        "designations": [
            {
                "id": 31,
                "name": "State Forest",
                "jurisdiction": {
                    "id": 1,
                    "name": "National"
                },
                "pas_count": 1
            },
            {
                "id": 1,
                "name": "UNESCO-MAB Biosphere Reserve",
                "jurisdiction": {
                    "id": 2,
                    "name": "International"
                },
                "pas_count": 37
            }
        ],
        "iucn_categories": [
            {
                "id": 7,
                "name": "VI",
                "pas_count": 1,
                "pas_percentage": 2.63
            },
            {
                "id": 8,
                "name": "Not Reported",
                "pas_count": 37,
                "pas_percentage": 97.37
            }
        ],
        "governances": [
            {
                "id": 7,
                "name": "Not Reported",
                "pas_count": 37,
                "pas_percentage": 97.37
            },
            {
                "id": 8,
                "name": "Sub-national ministry or agency",
                "pas_count": 1,
                "pas_percentage": 2.63
            }
        ]
    }
}
~~~
