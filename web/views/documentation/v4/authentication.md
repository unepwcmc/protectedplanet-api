# Authentication

To make successful HTTP calls to the Protected Planet API, you need an API token from the [request form](/request).

## Recommended: `Authorization` header (Bearer)

Send the token on every request using the `Authorization` header and the `Bearer` scheme:

~~~
$ curl -H "Authorization: Bearer YOUR_TOKEN" \
    https://api.protectedplanet.net/v4/protected_areas
~~~

Only the `Bearer` scheme is accepted in this header (for example, `Authorization: Bearer ca4703ffba6b9a26b2db73f78e56e088`).

You can verify your token with the `/test` endpoint:

## `GET /test`

~~~
$ curl -H "Authorization: Bearer YOUR_TOKEN" https://api.protectedplanet.net/test

{ "status": "Success!" }
~~~

## Legacy: `token` as query or form parameter

You may still pass `token` as a **query string** or **form** parameter. This is **deprecated** and will not be supported in next API version. Successful responses include:

- a `Deprecation` header, and  
- a `Warning` header (HTTP warning `299`) describing the migration to `Authorization: Bearer`.

~~~
$ curl "https://api.protectedplanet.net/test?token=YOUR_TOKEN"
~~~

For brevity, the `token` parameter is omitted from the rest of this documentation, as a valid token is always required (via header or parameter). New integrations should use `Authorization: Bearer` only.

## Errors

If a call is made with the token missing or invalid, the server responds with HTTP status `401 Unauthorized` and a JSON error body.
