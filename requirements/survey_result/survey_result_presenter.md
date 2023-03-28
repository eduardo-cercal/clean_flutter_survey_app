# Survey Result Presenter

> ## Rules
1. Call LoadSurveyResult on the loadData method
2. Notify the isLoadingStream as true before call the LoadSurveyResult
3. Notify the isLoadingStream as false on the LoadSurveyResults end
4. Notify the surveyResultStream with error on a LoadSurveyResult error return
5. Notify the surveyResultStream with a SurveyResult on a LoadSurveyResult success return