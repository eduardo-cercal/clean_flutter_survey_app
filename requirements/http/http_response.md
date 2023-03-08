# HTTP

> ## Success
1. Request with a valid verb (post)
2. Pass to the headres the JSON type content
3. Call request with a correct body
4. Ok - 200 and response with data
5. No content - 204 and response without data

> ## Errors
1. Bad request - 400
2. Unauthorized - 401
3. Forbidden - 403
4. Not found - 404
5. Internal server error - 500

> ## Exception - Another status code besides the above
1. Internal server error - 500

> ## Exception - Http request give a exception
1. Internal server error - 500

> ## Exception - Invalid verb http
1. Internal server error - 500