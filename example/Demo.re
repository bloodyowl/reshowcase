open Entry;

demo("Title", ({add}) => {
  add("font-size", () =>
    intProp("font size", 30, size =>
      stringProp("text", "hello", text =>
        [
          <h1
            style={ReactDOMRe.Style.make(
              ~fontSize=size->Belt.Int.toString ++ "px",
              (),
            )}>
            text->React.string
          </h1>,
        ]
      )
    )
  );
  add("normal", () =>
    stringProp("text", "hello", text => [<h1> text->React.string </h1>])
  );
});

demo("Button", ({add}) =>
  add("normal", () =>
    boolProp("disabled", false, disabled =>
      stringProp("text", "hello", text =>
        [<button disabled> text->React.string </button>]
      )
    )
  )
);

let dateProp =
  withControl((_date, setState) =>
    <button onClick={_event => setState(Js.Date.make())}>
      "Set to now"->React.string
    </button>
  );
demo("CustomProps", ({add}) =>
  add("now", () =>
    dateProp("date", Js.Date.make(), date =>
      [<h1> {date->Js.Date.toUTCString->React.string} </h1>]
    )
  )
);

start();
