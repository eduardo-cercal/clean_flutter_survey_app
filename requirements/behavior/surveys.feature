Feature: Survey List
    As a user
    I want see all surveys
    To know the results and give my opnion
Scenario: Online
    Given the user have internet connection
    When request to se the surveys
    Then the system must show the surveys
    And save the updated data on cache
Scenario: Offline
    Given the user have no internet connection
    When solicitade to se the surveys
    Then the system must show the surveys saved on cache the last connected time