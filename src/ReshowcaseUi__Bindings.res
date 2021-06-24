module URLSearchParams = {
  type urlSearchParams

  @new
  external make: string => urlSearchParams = "URLSearchParams"

  @return(nullable) @bs.send
  external get: (urlSearchParams, string) => option<string> = "get"
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
