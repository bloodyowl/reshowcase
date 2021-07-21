type rec t =
  Demo(Configs.demoUnitProps => React.element) | Category(Belt.MutableMap.String.t<t>)

type demos = Belt.MutableMap.String.t<t>
