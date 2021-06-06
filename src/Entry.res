open Belt

include Configs

type demo = {add: (string, Configs.demoUnitProps => React.element) => unit}

let demos = MutableMap.String.make()

let demo = (demoName, func) => {
  let demoUnits = MutableMap.String.make()
  let demo = {
    add: (demoUnitName, demo: Configs.demoUnitProps => React.element) =>
      demoUnits->MutableMap.String.set(demoUnitName, demo),
  }
  func(demo)
  demos->MutableMap.String.set(demoName, demoUnits->MutableMap.String.toArray->Map.String.fromArray)
}

let start = () =>
  switch ReactDOM.querySelector("#root") {
  | Some(root) =>
    let demos = demos->MutableMap.String.toArray->Map.String.fromArray
    ReactDOM.render(<ReshowcaseUi.App demos />, root)
  | None => ()
  }
