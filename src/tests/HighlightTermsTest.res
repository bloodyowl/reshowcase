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

let test = () => {
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

test()
