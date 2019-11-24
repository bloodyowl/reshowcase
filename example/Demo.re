open Entry;

demo("Title", ({add}) => {
  add("font-size", () =>
    Test.intProp("font size", 2, size =>
      Test.stringProp("text", "hello", text =>
        [
          <h1
            style={ReactDOMRe.Style.make(
              ~fontSize=size->Belt.Int.toString,
              (),
            )}>
            text->React.string
          </h1>,
        ]
      )
    )
  );
  add("normal", () =>
    Test.stringProp("text", "hello", text => [<h1> text->React.string </h1>])
  );
});

demo("Button", ({add}) =>
  add("normal", () =>
    Test.boolProp("font size", false, disabled =>
      Test.stringProp("text", "hello", text =>
        [<button disabled> text->React.string </button>]
      )
    )
  )
);

start();
