Feature: Play the mini crossword
  The player can fill in a word-square puzzle, check answers, and resume
  saved progress on an Android phone or Android TV.

  Scenario: Solve the crossword
    Given a new empty crossword
    When the player enters BALL, AREA, LEAD, and LADY in the Across clues
    And the player checks the answers
    Then the game celebrates the correct solution
    And the completed progress is saved

  Scenario: Switch the selected square to Down
    Given a new empty crossword
    When the player selects the same square twice
    Then the active clue changes from Across to Down

  Scenario: Check an incomplete crossword
    Given a new empty crossword
    When the player checks the answers
    Then the game reports that some squares remain empty

  Scenario: Restore saved progress
    Given a crossword with saved letters
    When the player opens the game
    Then the saved letters appear in their squares
