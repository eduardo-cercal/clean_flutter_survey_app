# SignUp Presenter

> ## Rules
1. Call the validation when change the email
2. Notify the emailErrorStream with the validation error, in a return error case
3. Notify the emailErrorStream with null, case the validation was no return
4. Not notify the emailErrorStream if the current value is equal to the last one
5. Notify the isFormValidStream after the email change
6. Call the validation when change the password
7. Notify the passwordErrorStream with the validation error, in a return error case
8. Notify the passwordErrorStream with null, case the validation was no return
9. Not notify the passwordErrorStream if the current value is equal to the last one
10. Notify the isFormValidStream after the password change
11. Call the validation when change the name
12. Notify the nameErrorStream with the validation error, in a return error case
13. Notify the nameErrorStream with null, case the validation was no return
14. Not notify the nameErrorStream if the current value is equal to the last one
15. Notify the isFormValidStream after the name change
16. Call the validation when change the passwordConfirmation
17. Notify the passwordConfirmationlErrorStream with the validation error, in a return error case
18. Notify the passwordConfirmationErrorStream with null, case the validation was no return
19. Not notify the passwordConfirmationErrorStream if the current value is equal to the last one
20. Notify the isFormValidStream after the passwordConfirmation change
21. The form is onlye valid if all the error streams are null and the fields have content
22. Not notify the isFormValidStream if the value is equal to the last one
23. Call AddAccount with correct values
24. Notify isLoadingStream as true before call AddAccount
25. Notify isLoadingStream as false on the AddAccount end
26. Notify mainErrorStream on AddAccount error return event
27. Close all the stream on dispose
28. Save the Account on cache in a success case
29. Notify mainErrorStream on the SaveCurrentAccount error return event
30. Take the user to the survey page on a success case
31. Take the user to the login page on the back to login event click
