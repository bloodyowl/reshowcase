open Belt

include Configs

open EntryT

let rootCategory: entityMap = MutableMap.String.make()

let demo = (f): unit => {
  let internalAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
    rootCategory->MutableMap.String.set(demoName, Demo(demoUnit))
  }

  let rec internalAddCategory = (categoryName: string, func, ~prevMap) => {
    let newCategory = MutableMap.String.make()

    prevMap->MutableMap.String.set(categoryName, Category(newCategory))

    let newAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
      newCategory->MutableMap.String.set(demoName, Demo(demoUnit))
    }

    let newFunctions = {
      addDemo: newAddDemo,
      addCategory: internalAddCategory(~prevMap=newCategory),
    }

    func(newFunctions)
  }

  let addFunctions = {
    addDemo: internalAddDemo,
    addCategory: internalAddCategory(~prevMap=rootCategory),
  }

  f(addFunctions)
}

let start = () =>
  switch ReactDOM.querySelector("#root") {
  | Some(root) =>
    let demos = rootCategory
    ReactDOM.render(<ReshowcaseUi.App demos />, root)
  | None => ()
  }
