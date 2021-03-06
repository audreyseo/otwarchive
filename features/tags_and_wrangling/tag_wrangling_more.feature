@tags @tag_wrangling
Feature: Tag wrangling: assigning wranglers, using the filters on the Wranglers page

  Scenario: Log in as a tag wrangler and see wrangler pages.
        View new tags in your fandoms
    Given I have loaded the fixtures
      And the following activated tag wranglers exist
      | login       | password      |
      | Enigel      | wrangulator   |
      | dizmo       | wrangulator   |
      And I have loaded the "roles" fixture

    # accessing tag wrangling pages
    When I am logged in as "dizmo" with password "wrangulator"
      And I follow "Tag Wrangling"
    Then I should see "Wrangling Home"
      And I should not see "first fandom"
    When I follow "Wranglers"
    Then I should see "Tag Wrangling Assignments"
      And I should see "first fandom"
    When I view the tag "first fandom"
    Then I should see "Edit"
    When I follow "Edit" within ".header"
    Then I should see "Edit first fandom Tag"
    
    # assigning media to a fandom
    When I fill in "tag[media_string]" with "TV Shows"
      And I press "Save changes"
    Then I should see "Tag was updated"
    When I follow "Tag Wrangling"
    Then I should see "Wrangling Home"
      And I should not see "first fandom"
    When I follow "Wranglers"
    Then I should see "Tag Wrangling Assignments"
      And I should see "first fandom"
    
    # assigning a fandom to oneself
    When I fill in "tag_fandom_string" with "first fandom"
      And I press "Assign"
      And I follow "Wrangling Home"
      And I follow "Wranglers"
    Then I should see "first fandom"
      And I should see "dizmo" within "ul.wranglers"
    Given I add the fandom "first fandom" to the character "Person A"
    
    # checking that wrangling home shows unfilterables
    When I follow "Wrangling Home"
    Then I should see "first fandom"
      And I should see "Unfilterable"
    When I follow "first fandom"
    Then I should see "Wrangle Tags for first fandom"
      And I should see "Characters (1)"
    
    When I log out
      And I am logged in as "Enigel" with password "wrangulator"
      And I follow "Tag Wrangling"
    
    # assigning another wrangler to a fandom
    When I follow "Wranglers"
      And I fill in "fandom_string" with "Ghost"
      And I press "Filter"
    Then I should see "Ghost Soup"
      And I should not see "first fandom"
    When I select "dizmo" from "assignments_10_"
      And I press "Assign"
    Then I should see "Wranglers were successfully assigned"

    # the filters on the Wranglers page
    When I select "TV Shows" from "media_id"
      And I fill in "fandom_string" with ""
      And I press "Filter"
    Then "TV Shows" should be selected within "media_id"
      And I should see "first fandom"
      And I should not see "second fandom"
    When I select "dizmo" from "wrangler_id"
      And I press "Filter"
    Then I should see "first fandom"
      And I should not see "Ghost Soup"
    When I select "" from "media_id"
      And I press "Filter"
    Then "dizmo" should be selected within "wrangler_id"
      And I should see "Ghost Soup"
      And I should see "first fandom"

  Scenario: Wrangler can remove self from a fandom

    Given the tag wrangler "tangler" with password "wr@ngl3r" is wrangler of "Testing"
      And I am logged in as "tangler" with password "wr@ngl3r"
    When I am on the wranglers page
      And I follow "x"
    Then "Testing" should not be assigned to the wrangler "tangler"
    When I edit the tag "Testing"
    Then I should see "Sign Up"

  Scenario: Wrangler can remove another wrangler from a fandom

    Given the tag wrangler "tangler" with password "wr@ngl3r" is wrangler of "Testing"
      And the following activated tag wrangler exists
      | login          |
      | wranglerette   |
    When I am logged in as "wranglerette"
      And I am on the wranglers page
      And I follow "x"
    Then "Testing" should not be assigned to the wrangler "tangler"
    When I edit the tag "Testing"
    Then I should see "Sign Up"

  Scenario: Updating multiple tags works.
    Given the following typed tags exists
        | name                                   | type         |
        | Cowboy Bebop                           | Fandom       |
        | Spike Spiegel is a sweetie             | Freeform     |
        | Jet Black is a sweetie                 | Freeform     |
      And I am logged in as a random user
      And I post the work "Brain Scratch" with fandom "Cowboy Bebop" with freeform "Spike Spiegel is a sweetie"
      And I post the work "Asteroid Blues" with fandom "Cowboy Bebop" with freeform "Jet Black is a sweetie"
     When the tag wrangler "lain" with password "lainnial" is wrangler of "Cowboy Bebop"
       And I follow "Tag Wrangling"
       And I follow "2"
       And I fill in "fandom_string" with "Cowboy Bebop"
       And I check the mass wrangling option for "Spike Spiegel is a sweetie"
       And I check the mass wrangling option for "Jet Black is a sweetie"
       And I press "Wrangle"
     Then I should see "The following tags were successfully wrangled to Cowboy Bebop: Spike Spiegel is a sweetie, Jet Black is a sweetie"

  Scenario: Updating multiple tags works and set them as canonical
    Given the following typed tags exists
        | name                                   | type         | canonical |
        | Cowboy Bebop                           | Fandom       | true      |
        | Faye Valentine is a sweetie            | Freeform     | false     |
        | Ed is a sweetie                        | Freeform     | false     |
      And I am logged in as a random user
      And I post the work "Asteroid Blues" with fandom "Cowboy Bebop" with freeform "Ed is a sweetie"
      And I post the work "Honky Tonk Women" with fandom "Cowboy Bebop" with freeform "Faye Valentine is a sweetie"
     When the tag wrangler "lain" with password "lainnial" is wrangler of "Cowboy Bebop"
       And I follow "Tag Wrangling"
       And I follow "2"
       And I fill in "fandom_string" with "Cowboy Bebop"
       And I check the mass wrangling option for "Faye Valentine is a sweetie"
       And I check the mass wrangling option for "Ed is a sweetie"
       And I check the canonical option for the tag "Faye Valentine is a sweetie"
       And I check the canonical option for the tag "Ed is a sweetie"
       And I press "Wrangle"
     Then I should see "The following tags were successfully wrangled to Cowboy Bebop: Faye Valentine is a sweetie, Ed is a sweetie"
       And the "Faye Valentine is a sweetie" tag should be canonical
       And the "Ed is a sweetie" tag should be canonical

  Scenario: Mass wrangling in the fandoms bins
    Given I am logged in as a tag wrangler
      And a media exists with name: "Anime & Manga", canonical: true
      And the following typed tags exists
        | name                                   | type         | canonical |
        | Cowboy Bebop                           | Fandom       | true      |
    When I go to the wrangling tools page
      And I follow "Fandoms by media (1)"
      And I check the wrangling option for "Cowboy Bebop"
      And I select "Anime & Manga" from "Wrangle to Media"
      And I press "Wrangle"
    Then I should not see "Cowboy Bebop"

  Scenario: A relationship can't be mass wrangled into a fandom that isn't a
  canonical tag
    Given I am logged in as a tag wrangler
      And the following typed tags exists
        | name                                   | type         | canonical |
        | Toby Daye/Tybalt                       | Relationship | true      |
        | October Daye Series - Seanan McGuire   | Fandom       | false     |
    When I go to the wrangling tools page
      And I follow "Relationships by fandom (1)"
      And I check the wrangling option for "Toby Daye/Tybalt"
      And I fill in "Wrangle to Fandom(s)" with "October Daye Series - Seanan McGuire"
      And I press "Wrangle"
    Then I should see "The following names are not canonical fandoms: October Daye Series - Seanan McGuire."

  Scenario: A relationship can be mass wrangled into a fandom that is a
  canonical tag
    Given I am logged in as a tag wrangler
      And the following typed tags exists
        | name                                   | type         | canonical |
        | Toby Daye/Tybalt                       | Relationship | true      |
        | October Daye Series - Seanan McGuire   | Fandom       | true      |
    When I go to the wrangling tools page
      And I follow "Relationships by fandom (1)"
      And I check the wrangling option for "Toby Daye/Tybalt"
      And I fill in "Wrangle to Fandom(s)" with "October Daye Series - Seanan McGuire"
      And I press "Wrangle"
    Then I should see "The following tags were successfully wrangled to October Daye Series - Seanan McGuire: Toby Daye/Tybalt"

  Scenario: A wrangler can make tags canonical while mass wrangling
    Given I am logged in as a tag wrangler
      And the following typed tags exists
        | name              | type         | canonical |
        | Cowboy Bebop      | Fandom       | true      |
        | Faye Valentine    | Character    | false     |
        | Ed                | Character    | false     |
      And I post the work "Honky Tonk Women" with fandom "Cowboy Bebop" with character "Faye Valentine" with second character "Ed"
    When I go to the wrangling tools page
      And I follow "Characters by fandom (2)"
      And I fill in "Wrangle to Fandom(s)" with "Cowboy Bebop"
      And I check the canonical option for the tag "Faye Valentine"
      And I check the canonical option for the tag "Ed"
      And I press "Wrangle"
    Then I should see "The following tags were successfully made canonical: Faye Valentine, Ed"

  Scenario: Tags that don't exist cause errors
    Given the following activated tag wrangler exists
      | login          |
      | wranglerette   |
    When I am logged in as "wranglerette"
    Then visiting "/tags/this_is_an_unknown_tag/edit" should fail with an error
      And visiting "/tags/this_is_an_unknown_tag/show" should fail with an error
      And visiting "/tags/this_is_an_unknown_tag/feed.atom" should fail with an error

  Scenario: Banned tags can only be viewed by an admin
    Given the following typed tags exists
        | name                                   | type         |
        | Cowboy Bebop                           | Banned       |
    When I am logged in as a random user
     And I view the tag "Cowboy Bebop"
    Then I should see "Sorry, you don't have permission to access the page you were trying to reach."
    When I am logged in as an admin
     And I view the tag "Cowboy Bebop"
    Then I should not see "Please log in as an admin"
     And I should see "Cowboy Bebop"

  @javascript
  Scenario: A user can see hidden tags
    Given the following typed tags exists
        | name                                   | type         | canonical |
        | Cowboy Bebop                           | Fandom       | true      |
        | Faye Valentine is a sweetie            | Freeform     | false     |
        | Ed is a sweetie                        | Freeform     | false     |
      And I am logged in as "first_user"
      And I post the work "Asteroid Blues" with fandom "Cowboy Bebop" with freeform "Ed is a sweetie" with second freeform "Faye Valentine is a sweetie"
      And I should see "Work was successfully posted."
      And I am logged in as "second_user" with password "secure_password" with preferences set to hidden warnings and additional tags
    When I view the work "Asteroid Blues"
      And I follow "Show additional tags"
    Then I should see "Additional Tags: Ed is a sweetie, Faye Valentine is a sweetie"
     And I should not see "Show additional tags"

  @javascript
  Scenario: A user can see hidden tags on a series

    Given the following typed tags exists
        | name                                   | type         | canonical |
        | Cowboy Bebop                           | Fandom       | true      |
        | Faye Valentine is a sweetie            | Freeform     | false     |
        | Ed is a sweetie                        | Freeform     | false     |
      And I limit myself to the Archive
      And I am logged in as "first_user"
      And I post the work "Asteroid Blues" with fandom "Cowboy Bebop" with freeform "Ed is a sweetie" as part of a series "Cowboy Bebop Blues"
      And I post the work "Wild Horses" with fandom "Cowboy Bebop" with freeform "Faye Valentine is a sweetie" as part of a series "Cowboy Bebop Blues"
    When I am logged in as "second_user" with password "secure_password" with preferences set to hidden warnings and additional tags
      And I go to first_user's user page
      And I follow "Cowboy Bebop Blues"
    Then I should see "Asteroid Blues"
      And I should see "Wild Horses"
      And I should not see "Ed is a sweetie"
    When I follow "Show additional tags"
    Then I should see "Ed is a sweetie"
      And I should not see "No Archive Warnings Apply" within "li.warnings"
    When I follow "Show warnings"
    Then I should see "No Archive Warnings Apply" within "li.warnings"
