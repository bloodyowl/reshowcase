module App: {
  [@react.component]
  let make:
    (
      ~demos: Belt.Map.String.t(
                Belt.Map.String.t(unit => list(React.element)),
              )
    ) =>
    React.element;
};
