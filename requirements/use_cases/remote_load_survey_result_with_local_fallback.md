# Remote Load Survey Result With Local Fallback

> ## Succes Case
1. System execute the remote implementation loadBySurvey
2. System replace cache data with returning data
3. System return the data

> ## Exception - Access denied
1. System rethrow the access denied exception

> ## Exception - Any other error
1. System execute the validate cache method
2. System execute the load cache method
3. System return data

> ## Exception - Get cache data error
1. System return a unexpected error