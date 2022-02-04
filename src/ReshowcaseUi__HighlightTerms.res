module List = Belt.List
module String = Js.String2
module Array = Js.Array2
module Color = ReshowcaseUi__Layout.Color

type textPart = Marked(string) | Unmarked(string)

type termPosition = Start | Middle | End

let getTermGroups = (~searchString, ~entityName) => {
  switch searchString {
  | "" => []
  | _ =>
    let searchString = searchString->String.toLowerCase
    let entityName = entityName->String.toLowerCase

    if entityName->String.includes(searchString) {
      [[searchString]]
    } else {

      let refinedSearchString =
        searchString
        ->String.replaceByRe(%re("/\\s+/g"), " ")
        ->String.replaceByRe(%re("/( , |, | ,)/g"), ",")

      refinedSearchString
      ->String.split(",")
      ->Array.map(s => s->String.split(" "))
      ->Array.map(arr => arr->Belt.Array.keepMap(s => String.length(s) > 1 ? Some(s) : None))
      // filter out meaningless one-char terms
    }
  }
}

let getMatchingTerms = (~searchString, ~entityName) => {
  let entityName = entityName->String.toLowerCase
  let termGroups = getTermGroups(~searchString, ~entityName)
  let includedTerms =
    termGroups->Array.filter(terms => terms->Array.every(term => String.includes(entityName, term)))
  Belt.Array.concatMany(includedTerms)
}

let getMarkRangeIndexes = (text, substring) => {
  let indexFrom = String.indexOf(String.toLowerCase(text), String.toLowerCase(substring))
  let indexTo = indexFrom + String.length(substring)
  (indexFrom, indexTo)
}

let getTermPosition = (range, max: int) =>
  switch range {
  | (0, _) => Start
  | (_, to_) if to_ >= max => End
  | _ => Middle
  }

let isRangeIntersection = ((from1, to1): (int, int), (from2, to2)) => {
  !(from2 > to1 && from2 > from1 && to2 > to1 && to2 > from1)
}

let mergeRangeIntersections = ranges => {
  let rec mergeRangeIntersections = (acc, ranges) => {
    switch (ranges, acc) {
    | (list{}, _) => acc
    | (list{range, ...ranges}, list{}) => mergeRangeIntersections(list{range}, ranges)
    | (list{(_, nextTo) as next, ...restRanges}, list{(prevFrom, _) as prev, ...accTail}) =>
      if isRangeIntersection(prev, next) {
        let mergedRange = (prevFrom, nextTo)
        mergeRangeIntersections(list{mergedRange, ...accTail}, restRanges)
      } else {
        mergeRangeIntersections(list{next, ...acc}, restRanges)
      }
    }
  }
  mergeRangeIntersections(list{}, ranges)->List.reverse
}

let compareInt: (int, int) => int = Pervasives.compare

let getMarkRanges = (text, terms) =>
  terms
  ->Array.map(term => getMarkRangeIndexes(text, term))
  ->Array.copy
  ->Array.sortInPlaceWith(((from1, to1), (from2, to2)) => compareInt(from1 + to1, from2 + to2))

let getMarkedAndUnmarkedParts = (ranges, text) => {
  let max = String.length(text)
  let getTerm = (from, to_) => String.slice(text, ~from, ~to_)

  let rec iter = (prevRangeEnd, acc, ranges) => {
    switch ranges {
    | list{} => prevRangeEnd < max ? list{Unmarked(getTerm(prevRangeEnd, max)), ...acc} : acc
    | list{(from, to_), ...tail} =>
      iter(
        to_,
        list{Marked(getTerm(from, to_)), Unmarked(getTerm(prevRangeEnd, from)), ...acc},
        tail,
      )
    }
  }

  let result = switch ranges {
  | list{} => list{}
  | list{(from, to_) as range, ...tail} =>
    switch getTermPosition(range, max) {
    | Start =>
      let acc = list{Marked(getTerm(from, to_))}
      iter(to_, acc, tail)
    | Middle =>
      let acc = list{Marked(getTerm(from, to_)), Unmarked(getTerm(0, from))}
      iter(to_, acc, tail)
    | End => list{Marked(getTerm(from, to_)), Unmarked(getTerm(0, from))}
    }
  }
  result->List.reverse
}

let getTextParts = (~text, ~terms) => {
  let markRanges = getMarkRanges(text, terms)->List.fromArray->mergeRangeIntersections
  getMarkedAndUnmarkedParts(markRanges, text)->List.toArray
}

@react.component
let make = (~text, ~terms) => {
  switch terms {
  | [] => text->React.string
  | _ => {
      let textParts = getTextParts(~text, ~terms)
      textParts
      ->Array.mapi((item, index) =>
        switch item {
        | Marked(text) =>
          <mark
            key={Belt.Int.toString(index)}
            style={ReactDOM.Style.make(~backgroundColor=Color.orange, ())}>
            {text->React.string}
          </mark>
        | Unmarked(text) =>
          <React.Fragment key={Belt.Int.toString(index)}> {text->React.string} </React.Fragment>
        }
      )
      ->React.array
    }
  }
}
