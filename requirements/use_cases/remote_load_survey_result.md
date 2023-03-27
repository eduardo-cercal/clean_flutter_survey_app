# Remote Load Survey Result

> ## Success Case
1. System make a request to the survey result API URL
2. System validates access token to know if the user have permission to see this data
3. System validates the API data recieve
4. System delivery the surveys data

> ## Exception - Invalid URL
1. System returns a unexpected error message

> ## Exception - Access deny
1. System returns a access deny error message

> ## Exception - Invalid reponse
1. System returns a unexpected error message

> ## Exception - Server fail
1. System returns a unexpected error message