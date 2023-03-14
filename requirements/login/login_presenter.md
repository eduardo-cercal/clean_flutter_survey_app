# Login Presenter

> ## Rules
1. Call validatation when alter the email
2. Notify the emailErrorStream with the same Validation error, if return a error
3. Notify the emailErrorStream with null, if the Validation doest return a error
4. Not notify the emailErrorStream if the value is iqual to the last one
5. Notify the formValidStream after change the email
6. Call Validation when change the password
7. Notify the passwordErrorStream with the same Validation error, if return a error
8. Notify the passwordErrorStream with null, if the Validation doest return a error
9. Not notify the passwordErrorStream if the value is iqual to the last one
10. Notify the formValidStream after change the password
11. The form is valid only if the error Stream are null and al the obligatory fields arent empty
12. Not notify the formValidStream if the value is iqual to the last one
13. Call the Authentication with the correct email and password
14. Notify the loadingStream was true before call the Authentication
15. Notify the loadingStream as false on the Authentication end
16. Notify the mainErrorStream if the Authentication return a DomainError
17. Close all Streams in the dispose
18. In a success case, save the Account in the cache
19. Notify the mainErrorStream if the SaveCurrentAccount return a error
20. In a success case, take the user to the Survey Page