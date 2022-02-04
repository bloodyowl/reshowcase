open Belt

module URLSearchParams = ReshowcaseUi__Bindings.URLSearchParams
module HighlightTerms = ReshowcaseUi__HighlightTerms

type t = Js.Dict.t<Entity.t>

let rec dig = (demos: t, categories: list<string>, demoName: string) => {
  switch categories {
  | list{} =>
    demos
    ->Js.Dict.get(demoName)
    ->Option.flatMap(entity =>
      switch entity {
      | Demo(demoUnit) => Some(demoUnit)
      | Category(_) => None
      }
    )
  | list{categoryName, ...categories} =>
    demos
    ->Js.Dict.get(categoryName)
    ->Option.flatMap(entity =>
      switch entity {
      | Category(demos) => dig(demos, categories, demoName)
      | Demo(_) => None
      }
    )
  }
}

let findDemo = (urlSearchParams: URLSearchParams.t, demoName, demos: t) => {
  let categories =
    urlSearchParams
    ->URLSearchParams.toArray()
    ->List.fromArray
    ->List.keep(((key, _value)) => key->Js.String2.startsWith("category"))
    ->List.sort(((categoryNum1, _), (categoryNum2, _)) =>
      String.compare(categoryNum1, categoryNum2)
    )
    ->List.map(((_categoryNum, categoryName)) => categoryName)

  demos->dig(categories, demoName)
}

let rec isNestedEntityMatchSearch = (demos: t, searchString) => {
  demos
  ->Js.Dict.entries
  ->Array.some(((entityName, entity)) => {
    let isEntityNameMatchSearch =
      HighlightTerms.getMatchingTerms(~searchString, ~entityName)->Array.size > 0
    switch entity {
    | Demo(_) => isEntityNameMatchSearch
    | Category(demos) => isEntityNameMatchSearch || isNestedEntityMatchSearch(demos, searchString)
    }
  })
}
