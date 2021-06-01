module ParentWindow = {
  @val external window: Dom.window = "window"

  @get
  external getParent: Dom.window => Dom.window = "parent"

  @get
  external getDocument: Dom.window => Dom.document = "document"

  @send
  external querySelector: (Dom.document, string) => Js.Nullable.t<Dom.element> = "querySelector"

  let getElementById = (id: string) =>
    window->getParent->getDocument->querySelector("#" ++ id)->Js.Nullable.toOption
}

module URLSearchParams = {
  type urlSearchParams

  @new
  external make: string => urlSearchParams = "URLSearchParams"

  @return(nullable) @bs.send
  external get: (urlSearchParams, string) => option<string> = "get"
}
