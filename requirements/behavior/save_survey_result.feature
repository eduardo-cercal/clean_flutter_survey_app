Feature: Answer a Survey
    In order to give my contribution and opnion to the community
    As a user
    I want answer a survey

    Scenario: With internet
        Given a user with internet connection
        When request to answer a survey
        Then the system save that answer
        And update the cache with new statistic
        And show the user the statistic updated version

    Scenario: Without internet
        Given a user without internet
        When request to answer a survey
        Then the system throws a error message
        
        