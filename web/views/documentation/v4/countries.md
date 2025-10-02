# Countries

## `GET /v4/countries`
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
                "protected_planet": "https://protectedplanet.net/country/PHL"
            },
            "pas_count": 558,
            "pas_national_count": 547,
            "pas_regional_count": 0,
            "pas_international_count": 11,
            "statistics": {
                "pa_land_area": 32739.84,
                "pa_marine_area": 19104.50889409,
                "percentage_pa_land_cover": 10.96,
                "land_area": 298762.86,
                "percentage_pa_marine_cover": 1.04,
                "marine_area": 1829405.068391,
                "polygons_count": 16,
                "points_count": 16,
                "oecm_polygon_count": 42,
                "oecm_point_count": 136,
                "protected_area_polygon_count": 265,
                "protected_area_point_count": 8,
                "percentage_oecms_pa_marine_cover": 3.628933257,
                "oecms_pa_land_area": 51650.29769,
                "oecms_pa_marine_area": 66591.94832,
                "percentage_oecms_pa_land_cover": 17.28736145
            },
            "pame_statistics": {
                "assessments": 39,
                "assessed_pas": 18,
                "pame_pa_land_area": 5807.692147,
                "pame_percentage_pa_land_cover": 1.943835,
                "pame_pa_marine_area": 1523.50019,
                "pame_percentage_pa_marine_cover": 0.083023
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
                "protected_planet": "https://protectedplanet.net/country/CHE"
            },
            "pas_count": 558,
            "pas_national_count": 547,
            "pas_regional_count": 0,
            "pas_international_count": 11,
            "statistics": {
                "pa_land_area": 4104.71,
                "pa_marine_area": null,
                "percentage_pa_land_cover": 9.93,
                "land_area": 41355.27,
                "percentage_pa_marine_cover": null,
                "marine_area": null,
                "polygons_count": 0,
                "points_count": 2
                "oecm_polygon_count": 0,
                "oecm_point_count": 0,
                "protected_area_polygon_count": 10772,
                "protected_area_point_count": 2
            },
            "pame_statistics": {
                "assessments": 20,
                "assessed_pas": 14,
                "pame_pa_land_area": 2610.795789,
                "pame_percentage_pa_land_cover": 6.313091,
                "pame_pa_marine_area": 0,
                "pame_percentage_pa_marine_cover": 0
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

## `GET /v4/countries/:iso_3`
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
            "protected_planet": "https://protectedplanet.net/country/USA"
        },
        "pas_count": 558,
        "pas_national_count": 547,
        "pas_regional_count": 0,
        "pas_international_count": 11,
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
            "pa_land_area": 1294475.95,
            "pa_marine_area": 1271408.029754,
            "percentage_pa_land_cover": 13.86,
            "land_area": 9336666.44,
            "percentage_pa_marine_cover": 12.46,
            "marine_area": 10201208.33913,
            "polygons_count": 1,
            "points_count": 37,
            "oecm_polygon_count": 0,
            "oecm_point_count": 0,
            "protected_area_polygon_count": 42770,
            "protected_area_point_count": 56,
            "percentage_oecms_pa_marine_cover": 3.628933257,
            "oecms_pa_land_area": 51650.29769,
            "oecms_pa_marine_area": 66591.94832,
            "percentage_oecms_pa_land_cover": 17.28736145
        },
        "pame_statistics": {
            "assessments": 101,
            "assessed_pas": 79,
            "pame_pa_land_area": 154799.8198,
            "pame_percentage_pa_land_cover": 1.631122,
            "pame_pa_marine_area": 1537642.023,
            "pame_percentage_pa_marine_cover": 17.89726
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
