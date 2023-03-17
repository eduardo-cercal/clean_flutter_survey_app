Feature: Login
    As a client
    I want to login and stay logged
    So I can see and answer question in a faster way

  Scenario: Valid Credentials
    Given a user that inform a set of valid credentials
    When request a login
    Then the system must send the user to the search screen
    And keeped logged

  Scenario: Invalid credentials
    Given a user that send a set of invalid credentials
    When request a login
    Then the system must return a error message
