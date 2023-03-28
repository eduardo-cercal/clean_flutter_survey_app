# Authorize HTTP Client Decorator

> ## Success
1. Get the access token from cache
2. Execute the HttpClient request with the new decorated header (x-access-token)
3. Return the same response as the HttpClient decorated

> ## Exception - Get cache data fail
1. Return a Http Forbidden - 403
2. Erase the access token from the cache

> ## Exception - HttpClient return any exception (besides forbidden)
1. Return the same exception

> ## Exception - HttpClient return a forbidden error
1. Return a Http Forbidden - 403
2. Erase the access token from the cache