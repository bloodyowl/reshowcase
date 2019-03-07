module App: {
  type state;

  type action;

  let make:
    (
      ~demos: Belt.Map.String.t(
                Belt.Map.String.t(
                  Configs.demoUnit => ReasonReact.reactElement,
                ),
              ),
      array(ReasonReact.reactElement)
    ) =>
    ReasonReact.component(state, ReasonReact.noRetainedProps, action);
};
