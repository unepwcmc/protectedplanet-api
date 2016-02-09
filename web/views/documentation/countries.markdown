# Countries

## `GET /countries`
Returns all countries, paginated. Accepts a `with_geometry` parameter, to
retrieve a `geojson` representation of the countries. The accepted parameters are:

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

---

## `GET /countries/:iso_3`
Returns the country with ISO3 `:iso_3`. A `geojson` representation
of the geometry is also returned. The accepted parameters are:

~~~
with_geometry (Boolean)
  If set, returns the geojson representation of the geometry of the country.
  Defaults to true.
~~~
