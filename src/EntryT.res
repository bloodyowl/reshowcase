type rec entity =
  Demo(string, Configs.demoUnitProps => React.element) | Category(Belt.MutableMap.String.t<entity>)

type rec addFunctions = {
  addDemo: (string, Configs.demoUnitProps => React.element) => unit,
  addCategory: (string, addFunctions => unit) => unit,
}

type entityMap = Belt.MutableMap.String.t<entity>
