# Remote Load Surveys With Local Fallback

> ## Succes case
1. System execute the remote implementation load
2. System replace cache data with the retrieve ones
3. System return the data

> ## Exception - Access deny
1. System pass on de access denied exception

> ## Exception - Any other error
1. System execute the validate cache data method
2. System execute the load cache data method
3. System return the data

> ## Exception - Get cache data error
1. System returns a unexpected error message