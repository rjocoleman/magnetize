Feature: configuration
  Before I can run my Magento application,
  I must configure Magento.

  Scenario: exit status
    When I run `magnetize configure --path .`
    Then the exit status should be 0
