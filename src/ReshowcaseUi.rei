module App: {
  let makeProps:
    (~demos: 'demos, ~key: string=?, unit) => {. "demos": 'demos};
  let make:
    {
      .
      "demos":
        Belt.Map.String.t(
          Belt.Map.String.t(
            Reshowcase.Configs.demoUnit => React.element,
          ),
        ),
    } =>
    React.element;
};
