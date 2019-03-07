type demo = {
  add: (string, Configs.demoUnit => ReasonReact.reactElement) => unit,
};

let demo: (Belt.MutableMap.String.key, demo => unit) => unit;

let start: unit => unit;
