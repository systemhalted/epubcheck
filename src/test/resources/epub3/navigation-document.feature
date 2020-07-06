Feature: EPUB 3 Navigation Document
  
  Checks conformance to specification rules defined for EPUB Navigation Documents:
  https://www.w3.org/publishing/epub32/epub-packages.html#sec-package-nav
  
  This feature file contains tests for EPUBCheck running in `nav` mode to check
  single Navigation Documents (`.xhtml` files).
  
  Note: Tests related to EPUB navigation rules in a full EPUB publication are
        defined in the `navigation.feature` feature file.

  Background: 
    Given EPUBCheck configured to check a Navigation Document
    And test files located at '/epub3/files/navigation-document/'


  ## 5.4 EPUB Navigation Document Definition

  Scenario: Verify a minimal Navigation Document
    When checking document 'minimal.xhtml'
    Then no errors or warnings are reported
    

  ### 5.4.1 The nav Element: Restrictions
      
  Scenario: Report an empty nav heading 
    When checking document 'content-model-heading-empty-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Heading elements must contain text'
    And no other errors or warnings are reported

  Scenario: Report a `p` element used as a nav heading 
    When checking document 'content-model-heading-p-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'element "p" not allowed here'
    And no other errors or warnings are reported
    
  Scenario: Report a missing item label
    When checking document 'content-model-item-label-missing-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'element "ol" not allowed yet; expected element "a" or "span"'
    And no other errors or warnings are reported
    
  Scenario: Report an empty item label
    When checking document 'content-model-item-label-empty-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Spans within nav elements must contain text'
    And no other errors or warnings are reported

  Scenario: Report a span label (e.g. with no link) used as a leaf
    When checking document 'content-model-item-span-leaf-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'element "li" incomplete; missing required element "ol"'
    And no other errors or warnings are reported

  Scenario: Report a nav link without content
    When checking document 'content-model-link-empty-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Anchors within nav elements must contain text'
    And no other errors or warnings are reported
    
  Scenario: Report a nav link without content
    When checking document 'content-model-link-span-empty-error.xhtml'
    Then the following errors are reported (two errors as a side effect)
       | RSC-005 | Anchors within nav elements must contain text |
       | RSC-005 | Spans within nav elements must contain text |
    And no other errors or warnings are reported

  Scenario: Report a nav list without content
    When checking document 'content-model-ol-empty-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'element "ol" incomplete'
    And no other errors or warnings are reported    


  ### 5.4.2 The nav Element: Types

  #### 5.4.2.2 The toc nav Element

  Scenario: Allow a nested `toc` nav
    When checking document 'nav-toc-nested-valid.xhtml'
    Then no errors or warnings are reported

  Scenario: Report a missing `toc` nav
    When checking document 'nav-toc-missing-error.xhtml'
    Then error RSC-005 is reported (toc nav missing)
    And warning RSC-017 is reported (side-effect warning because of the type-less nav)
    And no other errors or warnings are reported

  #### 5.4.2.3 The page-list nav Element  

  Scenario: Allow a `page-list` nav
    When checking document 'nav-page-list-valid.xhtml'
    Then no errors or warnings are reported

  Scenario: Report multiple occurences of `page-list` nav
    When checking document 'nav-page-list-multiple-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Multiple occurrences of the \'page-list\' nav element'
    And no other errors or warnings are reported

  #### 5.4.2.4 The landmarks nav Element

  Scenario: Allow a `landmarks` nav
    When checking document 'nav-landmarks-valid.xhtml'
    Then no errors or warnings are reported

  Scenario: Report a link without an epub:type in a `landmarks` nav
    When checking document 'nav-landmarks-link-type-missing-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Missing epub:type attribute on anchor inside \'landmarks\' nav'
    And no other errors or warnings are reported

  Scenario: Report multiple occurences of `landmarks` nav
    When checking document 'nav-landmarks-multiple-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'Multiple occurrences of the \'landmarks\' nav element'
    And no other errors or warnings are reported

  Scenario: Allow multiple entries with the same epub:type in a `landmarks` nav when pointing to different resources
    When checking document 'nav-landmarks-type-twice-valid.xhtml'
    Then no errors or warnings are reported

  Scenario: Report multiple entries with the same epub:type in a `landmarks` nav
    When checking document 'nav-landmarks-type-twice-same-resource-error.xhtml'
    Then error RSC-005 is reported 2 times
    And the message contains 'Another landmark was found with the same epub:type and same reference'
    And no other errors or warnings are reported
    
  #### 5.4.2.5 Other nav Elements

  Scenario: Allow a `lot` nav
    When checking document 'nav-other-lot-valid.xhtml'
    Then no errors or warnings are reported

  Scenario: Report a nav without a declared epub:type
    When checking document 'nav-other-type-missing-warning.xhtml'
    Then warning RSC-017 is reported
    And no other errors or warnings are reported
    
  Scenario: Report a nav other than 'toc'/'page-list'/'landmarks' without a heading
    When checking document 'nav-other-heading-missing-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'must have a heading'
    And no other errors or warnings are reported


  ### 5.4.3 The hidden attribute

  Scenario: Allow a hidden nav (set on a `page-list` nav)
    When checking document 'hidden-nav-valid.xhtml'
    Then no errors or warnings are reported
    
  Scenario: Report a hidden attribute with a wrong value
    When checking document 'hidden-attribute-invalid-error.xhtml'
    Then error RSC-005 is reported
    And the message contains 'value of attribute "hidden" is invalid'
    And no other errors or warnings are reported