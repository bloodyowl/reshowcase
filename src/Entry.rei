type demo = {add: (string, unit => list(React.element)) => unit};

let demo: (Belt.MutableMap.String.key, demo => unit) => unit;

let start: unit => unit;
