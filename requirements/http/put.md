# HTTP Put

> ## Success
1. Request with the corrent method (put)
2. Give a content type JSON to the headers
3. Ok - 200 and response with data
4. No content - 204 and response without data

> ## Errors
1. Bad request - 400
2. Unauthorized - 401
3. Forbiden - 403
4. Not found - 404
5. Internal server error - 500

> ## Exception - Status code unlinke the abve
1. Internal server error - 500

> ## Exception - Http request throw a exception
1. Internal server error - 500

> ## Exception - Http invalid method
1. Internal server error - 500