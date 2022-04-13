module HighlightTerms = ReshowcaseUi__HighlightTerms

@val external process: 'a = "process"

@module external util: 'a = "util"

let inspect = (value): string =>
  util["inspect"](value, {"compact": false, "depth": 20, "colors": true})

let exitWithError = () => process["exit"](1)

let isEqual = (~msg="", v1, v2) => {
  if v1 != v2 {
    Js.log2("Test failed:", msg)
    Js.log2("expected this: ", inspect(v1))
    Js.log2("to be equal to: ", inspect(v2))
    exitWithError()
  }
}

let getTextPartsTest = () => {
  isEqual(
    ~msg="Term at the start",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["One"]),
    [Marked("One"), Unmarked("TwoThreeFourFive")],
  )

  isEqual(
    ~msg="Term at the middle",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["Three"]),
    [Unmarked("OneTwo"), Marked("Three"), Unmarked("FourFive")],
  )

  isEqual(
    ~msg="Term at the end",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["Five"]),
    [Unmarked("OneTwoThreeFour"), Marked("Five")],
  )

  isEqual(
    ~msg="Terms intersection",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["OneTwo", "TwoThree"]),
    [Marked("OneTwoThree"), Unmarked("FourFive")],
  )

  isEqual(
    ~msg="Two terms, start and middle",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["One", "Three"]),
    [Marked("One"), Unmarked("Two"), Marked("Three"), Unmarked("FourFive")],
  )

  isEqual(
    ~msg="Two terms in the middle",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["Two", "Four"]),
    [Unmarked("One"), Marked("Two"), Unmarked("Three"), Marked("Four"), Unmarked("Five")],
  )

  isEqual(
    ~msg="Two terms, middle and end",
    HighlightTerms.getTextParts(~text="OneTwoThreeFourFive", ~terms=["Three", "Five"]),
    [Unmarked("OneTwo"), Marked("Three"), Unmarked("Four"), Marked("Five")],
  )
}

let getTermGroupsTest = () => {
  isEqual(
    ~msg="Empty search string, no groups",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString=""),
    [],
  )

  isEqual(
    ~msg="The same term as entity name is a group with a single item",
    HighlightTerms.getTermGroups(
      ~entityName="OneTwoThreeFourFive",
      ~searchString="onetwothreefourfive",
    ),
    [["onetwothreefourfive"]],
  )

  isEqual(
    ~msg="Two terms with space is a single group with two terms",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString="one two"),
    [["one", "two"]],
  )

  isEqual(
    ~msg="Two terms with comma are two groups.",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString="one,two"),
    [["one"], ["two"]],
  )

  isEqual(
    ~msg="Three terms with comma (2 and 1)",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString="one two, three"),
    [["one", "two"], ["three"]],
  )

  isEqual(
    ~msg="Three terms with comma (1 and 2)",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString="one, two three"),
    [["one"], ["two", "three"]],
  )

  isEqual(
    ~msg="One letter term is filtered out",
    HighlightTerms.getTermGroups(~entityName="OneTwoThreeFourFive", ~searchString="one t"),
    [["one"]],
  )
}

let getMatchingTermsTest = () => {
  // If we use spaces between terms we expect all of them to be included to get more precise search results.
  // If we use commas between terms we expect terms from one or another group to be included.

  isEqual(
    ~msg="One exact term match",
    HighlightTerms.getMatchingTerms(
      ~entityName="OneTwoThreeFourFive",
      ~searchString="onetwothreefourfive",
    ),
    ["onetwothreefourfive"],
  )

  isEqual(
    ~msg="Single term match",
    HighlightTerms.getMatchingTerms(~entityName="OneTwoThreeFourFive", ~searchString="one"),
    ["one"],
  )

  isEqual(
    ~msg="Two required terms match",
    HighlightTerms.getMatchingTerms(~entityName="OneTwoThreeFourFive", ~searchString="one two"),
    ["one", "two"],
  )

  isEqual(
    ~msg="Two required terms or one required term, all match",
    HighlightTerms.getMatchingTerms(
      ~entityName="OneTwoThreeFourFive",
      ~searchString="one two, three",
    ),
    ["one", "two", "three"],
  )

  isEqual(
    ~msg="Two terms, the alternative term is missing, one match",
    HighlightTerms.getMatchingTerms(
      ~entityName="OneTwoThreeFourFive",
      ~searchString="missing, one",
    ),
    ["one"],
  )

  isEqual(
    ~msg="Two required terms, one of them is missing, no match",
    HighlightTerms.getMatchingTerms(~entityName="OneTwoThreeFourFive", ~searchString="one missing"),
    [],
  )
}

getTextPartsTest()
getTermGroupsTest()
getMatchingTermsTest()
