type demo = {add: (string, unit => list(React.element)) => unit};

let withControl:
  (
    ('a, 'a => unit) => ReasonReact.reactElement,
    string,
    'a,
    'a => list(ReasonReact.reactElement)
  ) =>
  list(ReasonReact.reactElement);

let boolProp:
  (string, bool, bool => list(ReasonReact.reactElement)) =>
  list(ReasonReact.reactElement);

let intProp:
  (string, int, int => list(ReasonReact.reactElement)) =>
  list(ReasonReact.reactElement);

let stringProp:
  (string, string, string => list(ReasonReact.reactElement)) =>
  list(ReasonReact.reactElement);

let demo: (Belt.MutableMap.String.key, demo => unit) => unit;

let start: unit => unit;
