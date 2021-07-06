@@warning("-a")

open Belt

type rec entity = Demo(string, Configs.demoUnitProps => React.element) | Category(Belt.MutableMap.String.t<entity>)

type rec addFunctions = {
  addDemo: (string, Configs.demoUnitProps => React.element) => unit,
  addCategory: (string, addFunctions => unit) => unit,
}

type entityMap = Belt.MutableMap.String.t<entity>

let rootCategory: entityMap = MutableMap.String.make()

let rootAdd = (f): unit => {
  let internalAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
    rootCategory->MutableMap.String.set(demoName, Demo(demoName, demoUnit))
  }

  let rec internalAddCategory = (categoryName: string, func, ~prevMap) => {
    let newCategory = MutableMap.String.make()

    prevMap->MutableMap.String.set(categoryName, Category(newCategory))

    let newAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
      newCategory->MutableMap.String.set(demoName, Demo(demoName, demoUnit))
    }

    let newFunctions = {
      addDemo: newAddDemo,
      addCategory: internalAddCategory(~prevMap=newCategory),
    }

    func(newFunctions)
  }

  let addFunctions = {addDemo: internalAddDemo, addCategory: internalAddCategory(~prevMap=rootCategory)}

  f(addFunctions)
}

rootAdd(({addDemo, addCategory}) => {
  addDemo("lala", _propsApi => <p> {"LALA element"->React.string} </p>)

  addCategory("Headings1", ({addDemo, addCategory}) => {
    addDemo("H1", _propsApi => React.null)
    addDemo("H2", _propsApi => React.null)

    addCategory("Headings2", ({addDemo, addCategory}) => {
      addDemo("H11", _propsApi => React.null)
      addDemo("H22", _propsApi => React.null)
    })
  })
})
