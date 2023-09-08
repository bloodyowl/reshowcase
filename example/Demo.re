open Reshowcase.Entry;

demo(({addDemo: _, addCategory}) =>
  addCategory("Buttons", ({addDemo, addCategory: _}) => {
    addDemo("Normal", ({string, bool, _}) => {
      let disabled = bool("Disabled", false);
      <button
        disabled
        style={ReactDOM.Style.make(
          ~backgroundColor=
            string(
              "Color",
              ~options=[|
                ("Red", "#E02020"),
                ("Green", "#6DD400"),
                ("Blue", "#0091FF"),
              |],
              "#0091FF",
            ),
          ~color="#fff",
          ~border="none",
          ~padding="10px",
          ~borderRadius="10px",
          ~fontFamily="inherit",
          ~fontSize="inherit",
          ~opacity=if (disabled) {"0.5"} else {"1"},
          ~cursor=if (disabled) {"default"} else {"pointer"},
          (),
        )}>
        {string("Text", "hello")->React.string}
      </button>;
    });
    addDemo("Huge", ({string, bool, _}) => {
      let disabled = bool("Disabled", false);
      <button
        disabled
        style={ReactDOM.Style.make(
          ~backgroundColor=
            string(
              "Color",
              ~options=[|
                ("Red", "#E02020"),
                ("Green", "#6DD400"),
                ("Blue", "#0091FF"),
              |],
              "#0091FF",
            ),
          ~color="#fff",
          ~border="none",
          ~padding="20px",
          ~borderRadius="10px",
          ~fontFamily="inherit",
          ~fontSize="30px",
          ~opacity=if (disabled) {"0.5"} else {"1"},
          ~cursor=if (disabled) {"default"} else {"pointer"},
          (),
        )}>
        {string("Text", "Hello")->React.string}
      </button>;
    });
  })
);

demo(({addDemo: _, addCategory}) =>
  addCategory("Typography", ({addDemo: _, addCategory}) => {
    addCategory("Headings", ({addDemo, addCategory: _}) => {
      addDemo("H1", ({string, int, _}) =>
        <h1
          style={ReactDOM.Style.make(
            ~fontSize=
              {let size =
                 int("Font size", {min: 0, max: 100, initial: 30, step: 1});
               {j|$(size)px|j}},
            (),
          )}>
          {string("Text", "hello")->React.string}
        </h1>
      );
      addDemo("H2", ({string, _}) =>
        <h2> {string("Text", "hello")->React.string} </h2>
      );
    });
    addCategory("Text", ({addDemo, addCategory: _}) => {
      addDemo("Paragraph", ({string, _}) =>
        <p> {string("Text", "hello")->React.string} </p>
      );
      addDemo("Italic", ({string, _}) =>
        <i> {string("Text", "hello")->React.string} </i>
      );
    });
  })
);

demo(({addDemo, addCategory: _}) =>
  addDemo("Code example", _propsApi =>
    <code
      style={ReactDOM.Style.make(
        ~whiteSpace="pre",
        ~padding="0",
        ~backgroundColor=Reshowcase.Layout.Color.lightGray,
        (),
      )}>
      "\ndemo(({addDemo: _, addCategory}) => {\n  addCategory(\"Typography\", ({addDemo: _, addCategory}) => {\n    addCategory(\"Headings\", ({addDemo, addCategory: _}) => {\n      addDemo(\"H1\", ({string, int}) =>\n        <h1\n          style={ReactDOM.Style.make(\n            ~fontSize={\n              let size = int(\"Font size\", {min: 0, max: 100, initial: 30, step: 1})\n              j`$(size)px`\n            },\n            (),\n          )}>\n          {string(\"Text\", \"hello\")->React.string}\n        </h1>\n      )\n      addDemo(\"H2\", ({string}) => <h2> {string(\"Text\", \"hello\")->React.string} </h2>)\n    })\n\n    addCategory(\"Text\", ({addDemo, addCategory: _}) => {\n      addDemo(\"Paragraph\", ({string}) => <p> {string(\"Text\", \"hello\")->React.string} </p>)\n      addDemo(\"Italic\", ({string}) => <i> {string(\"Text\", \"hello\")->React.string} </i>)\n    })\n  })\n})\n\nstart()\n\n"
      ->React.string
    </code>
  )
);

demo(({addDemo: _, addCategory}) =>
  addCategory("Test search", ({addDemo, addCategory: _}) => {
    addDemo("OneTwoThreeFour", _ => React.null);
    addDemo("OneTwoThreeFive", _ => React.null);
    addDemo("OneTwoFourSeven", _ => React.null);
  })
);

start();
