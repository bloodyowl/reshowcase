module URLSearchParams = {
  type t

  @new
  external make: string => t = "URLSearchParams"

  @return(nullable) @bs.send
  external get: (t, string) => option<string> = "get"

  @bs.send
  external forEach: (t, (string, string) => unit) => unit = "forEach"

  let toArray = (t, ()) => {
    let array = []
    t->forEach((value, key) => Js.Array2.push(array, (key, value))->ignore)
    array
  }
}

module Window = {
  module Message = {
    type t = RightSidebarDisplayed

    let toString = (message: t) =>
      switch message {
      | RightSidebarDisplayed => "RightSidebarDisplayed"
      }

    let fromStringOpt = (string): option<t> =>
      switch string {
      | "RightSidebarDisplayed" => Some(RightSidebarDisplayed)
      | _ => None
      }
  }

  @val external window: {..} = "window"

  let addMessageListener = (func: Js.t<'a> => unit): unit =>
    window["addEventListener"](. "message", func, false)

  let postMessage = (window, message: Message.t) =>
    window["postMessage"](. message->Message.toString, "*")
}

module LocalStorage = {
  type t
  @return(nullable) @send external getItem: (t, string) => option<string> = "getItem"
  @send external setItem: (t, string, string) => unit = "setItem"
  @send external removeItem: (t, string) => unit = "removeItem"
  @val external localStorage: t = "localStorage"
}
