# Survey Result Page

> ## Rules
1. Call Get Survey Result method on screen load
2. Show loading when recieve a isLoading event as true from the presenter
3. Hide loading when recieve a isLoading event as false or null from the presenter
4. Show the error message and hide the list when recieve a SurveyResult with error
5. Hide the error message and show the survey result when recieve a SurveyResult with data
6. Call the GetSurveyResult method when when click the reload buttom
7. Show the survey question
8. Show the questions alternatives
9. Show the percentage of each alternative
10. Show the icon disable with is not the user answer
11. Show the icon enable if is the user answer
12. If the alternative has image, loaded from the URL
13. If the alternative has no image, dont load a image