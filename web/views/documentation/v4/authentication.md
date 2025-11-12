# Authentication

To make successful HTTP calls to the Protected Planet API, you must have a API token, obtainable through a simple [request form](/request).

Once received, you will need to append the `token` parameter to whichever set of parameters your API calls will contain. For brevity, the `token` parameter is omitted from the rest of this documentation, as it is always required. If an API call is executed with the `token` parameter missing or invalid, the server will respond with HTTP code `401 (Unauthorized)` and an error message in a `JSON` object.

You can use the `/test` endpoint to check for the validity of your API token:

## `GET /test`

~~~
$ curl https://api.protectedplanet.net/test?token=ca4703ffba6b9a26b2db73f78e56e088

{ status: "Success!" }
~~~