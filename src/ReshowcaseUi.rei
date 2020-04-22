module App: {
  [@react.component]
  let make:
    (
      ~demos: Belt.Map.String.t(
                Belt.Map.String.t(Configs.demoUnit => React.element),
              )
    ) =>
    React.element;
};
