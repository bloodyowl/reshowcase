module List = Belt.List
module String = Js.String2
module Array = Js.Array2
module Color = ReshowcaseUi__Layout.Color

type textPart = Marked(string) | Unmarked(string)

type termPosition = Start | Middle | End

type markRange = (int, int)

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

let getMarkRanges = (text, terms) =>
  terms->Array.map(term => getMarkRangeIndexes(text, term))->Array.copy->Array.sortInPlace

let getMarkedUnmarkedParts = (ranges, text) => {
  let max = String.length(text)
  let getTerm = (from, to_) => String.slice(text, ~from, ~to_)

  let rec iter = ((_, prevTo), acc, ranges) => {
    switch ranges {
    | list{} => prevTo < max ? list{Unmarked(getTerm(prevTo, max)), ...acc} : acc
    | list{(from, to_) as previous, ...tail} =>
      iter(
        previous,
        list{Marked(getTerm(from, to_)), Unmarked(getTerm(prevTo, from)), ...acc},
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
      let previous = range
      iter(previous, acc, tail)
    | Middle =>
      let acc = list{Marked(getTerm(from, to_)), Unmarked(getTerm(0, from))}
      let previous = range
      iter(previous, acc, tail)
    | End => list{Marked(getTerm(from, to_)), Unmarked(getTerm(0, to_))}
    }
  }
  result->List.reverse
}

let getTextParts = (~text, ~terms) => {
  let markRanges = getMarkRanges(text, terms)->List.fromArray->mergeRangeIntersections
  getMarkedUnmarkedParts(markRanges, text)->List.toArray
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
