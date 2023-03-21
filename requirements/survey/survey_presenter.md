# Survey Presenter

> ## Rules
1. Call LoadSurveys on loadData method
2. Notify isLoadingStream as true before call LoadSurveys
3. Notify isLoadingStream as false on loadSurveys end
4. Notify surveysStream with error if LoadSurveys returns error
5. Notify surveysStream with a surveys list if LoadSurveys returns success
6. Take the user to eh Result Survey screen when click on a surveys