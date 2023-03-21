# Local Load Surveys

> ## Success Case
1. System request the surveys data from the cache
2. System delivery the surveys data

> ## Exception - Empty cache
1. System returns a unexpected error message

---

# Local Validate Surveys

> ## Success Case
1. System validate the data recieved from the cache

> ## Exception - Invalid cache data
1. System clean the cache data

---

# Local Save Surveys

> ## Success Case
1. System validates the survey data
2. System erase old cache data
3. System save new cache data

> ## Exception - Erase cache data error
1. System return a error message

> ## Exception - Save cache data error
1. System return a error message