module URLSearchParams = {
  type t;

  [@mel.new] external make: string => t = "URLSearchParams";

  [@mel.return nullable] [@mel.send]
  external get: (t, string) => option(string) = "get";

  [@mel.send]
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

  external window: Js.t({..}) = "window";

  let addMessageListener = (func: Js.t('a) => unit): unit =>
    window##addEventListener("message", func, false);

  let postMessage = (window, message: Message.t): unit =>
    window##postMessage(message->Message.toString, "*");
};

module LocalStorage = {
  type t;

  [@mel.return nullable] [@mel.send]
  external getItem: (t, string) => option(string) = "getItem";

  [@mel.send] external setItem: (t, string, string) => unit = "setItem";
  [@mel.send] external removeItem: (t, string) => unit = "removeItem";
  external localStorage: t = "localStorage";
};
