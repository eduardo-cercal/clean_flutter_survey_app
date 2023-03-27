Feature: Survey Result
    In order to see a surveys answer
    As a user
    I want know the community opnion about some topic

    Scenario: With connection
        Given the user has connection
        When request to see a surveys answer
        Then the system must show the surveys answer
        And save the updated data on the cache
    
    Scenario: Without connection
        Given the user has no internet connection
        When request to see a surveys answer
        Then the system must show the suveyrs answer from a last access saved cache
    
    