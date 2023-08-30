module URLSearchParams = {
  type t;

  [@bs.new] external make: string => t = "URLSearchParams";

  [@bs.return nullable] [@bs.send]
  external get: (t, string) => option(string) = "get";

  [@bs.send]
  external forEach: (t, (string, string) => unit) => unit = "forEach";

  let toArray = (t, ()) => {
    let array = [||];
    t->(
         forEach((value, key) => Js.Array2.push(array, (key, value))->ignore)
       );
    array;
  };
};

module Window = {
  module Message = {
    type t =
      | RightSidebarDisplayed;

    let toString = (message: t) =>
      switch (message) {
      | RightSidebarDisplayed => "RightSidebarDisplayed"
      };

    let fromStringOpt = (string): option(t) =>
      switch (string) {
      | "RightSidebarDisplayed" => Some(RightSidebarDisplayed)
      | _ => None
      };
  };

  [@bs.val] external window: Js.t({..}) = "window";

  let addMessageListener = (func: Js.t('a) => unit): unit =>
    window##addEventListener("message", func, false);

  let postMessage = (window, message: Message.t): unit =>
    window##postMessage(message->Message.toString, "*");
};

module LocalStorage = {
  type t;

  [@bs.return nullable] [@bs.send]
  external getItem: (t, string) => option(string) = "getItem";

  [@bs.send] external setItem: (t, string, string) => unit = "setItem";
  [@bs.send] external removeItem: (t, string) => unit = "removeItem";
  [@bs.val] external localStorage: t = "localStorage";
};
