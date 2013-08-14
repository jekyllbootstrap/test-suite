Feature: Drafts
  As a content publisher
  I want to maintain drafts
  so that I can manage work-in-progress content alongside published content

  Scenario: Defining a draft
    Given the stock jekyll-bootstrap source
      And some files with values:
        | file |
        | _drafts/2000-01-01-hello.md |
    When I compile my site
    Then my compiled site should NOT have the file "2000/01/01/hello/index.html"
      And my compiled site should NOT have the file "drafts/hello/index.html"

  Scenario: Defining a nested draft
    Given the stock jekyll-bootstrap source
      And some files with values:
        | file |
        | _drafts/derp/2000-01-01-hello.md |
    When I compile my site
    Then my compiled site should NOT have the file "2000/01/01/hello/index.html"
      And my compiled site should NOT have the file "drafts/derp/hello/index.html"
