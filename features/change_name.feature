Feature: change name

  Scenario: change name
    Given I am on the homepage
    Then I should see my name as "Alice"
    When I change my name to "Bob"
    Then I should see my name as "Bob"
