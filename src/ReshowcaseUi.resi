module App: {
  @react.component
  let make: (
    ~demos: Belt.Map.String.t<Belt.Map.String.t<Configs.demoUnitProps => React.element>>,
  ) => React.element
}
