# Protected Areas

## `GET /protected_areas`
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

---

## `GET /protected_areas/:wdpa_id`
Returns the protected area with WDPA ID `:wdpa_id`. A `geojson` representation
of the geometry is also returned.

The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the protected areas.
  Defaults to true.
~~~

---

## `GET /protected_areas/search`
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
