@@warning("-a")

open Belt

type rec entity = Demo(string, React.element) | Category(Belt.MutableMap.String.t<entity>)

type rec addFunctions = {
  addDemo: (string, React.element) => unit,
  addCategory: (string, addFunctions => unit) => unit,
}

type entityMap = Belt.MutableMap.String.t<entity>

let rootEntity: entityMap = MutableMap.String.make()

let rootAdd = (f): unit => {
  let internalAddDemo = (demoName: string, element: React.element) => {
    rootEntity->MutableMap.String.set(demoName, Demo(demoName, element))
  }

  let rec internalAddCategory = (categoryName: string, func, ~prevMap) => {
    let newCategory = MutableMap.String.make()

    prevMap->MutableMap.String.set(categoryName, Category(newCategory))

    let newAddDemo = (demoName: string, element: React.element) => {
      newCategory->MutableMap.String.set(demoName, Demo(demoName, element))
    }

    let newFunctions = {
      addDemo: newAddDemo,
      addCategory: internalAddCategory(~prevMap=newCategory),
    }

    func(newFunctions)
  }

  let functions = {addDemo: internalAddDemo, addCategory: internalAddCategory(~prevMap=rootEntity)}

  f(functions)
}

rootAdd(({addDemo, addCategory}) => {
  addDemo("lala", <p> {"LALA element"->React.string} </p>)

  addCategory("Headings1", ({addDemo, addCategory}) => {
    addDemo("H1", React.null)
    addDemo("H2", React.null)

    addCategory("Headings2", ({addDemo, addCategory}) => {
      addDemo("H11", React.null)
      addDemo("H22", React.null)
    })
  })
})

let logShit = () => Js.log(rootEntity)

let add = (demoName: string, addDemo): unit => {
  let _ = demoName
  let demoUnits = []

  let internalAddDemo = (name: string, element: React.element) =>
    demoUnits->Js.Array2.push((name, element))->ignore

  addDemo(internalAddDemo)
}

add("Typography", addDemo => {
  addDemo("TextBase", React.null)
})
