open Entry

demo(({addDemo: _, addCategory}) => {
  addCategory("Buttons", ({addDemo, addCategory: _}) => {
    addDemo("Normal", ({string, bool}) => {
      let disabled = bool("Disabled", false)
      <button
        disabled
        style={ReactDOM.Style.make(
          ~backgroundColor=string(
            "Color",
            ~options=[("Red", "#E02020"), ("Green", "#6DD400"), ("Blue", "#0091FF")],
            "#0091FF",
          ),
          ~color="#fff",
          ~border="none",
          ~padding="10px",
          ~borderRadius="10px",
          ~fontFamily="inherit",
          ~fontSize="inherit",
          ~opacity=disabled ? "0.5" : "1",
          ~cursor=disabled ? "default" : "pointer",
          (),
        )}>
        {string("Text", "hello")->React.string}
      </button>
    })

    addDemo("Huge", ({string, bool}) => {
      let disabled = bool("Disabled", false)
      <button
        disabled
        style={ReactDOM.Style.make(
          ~backgroundColor=string(
            "Color",
            ~options=[("Red", "#E02020"), ("Green", "#6DD400"), ("Blue", "#0091FF")],
            "#0091FF",
          ),
          ~color="#fff",
          ~border="none",
          ~padding="20px",
          ~borderRadius="10px",
          ~fontFamily="inherit",
          ~fontSize="30px",
          ~opacity=disabled ? "0.5" : "1",
          ~cursor=disabled ? "default" : "pointer",
          (),
        )}>
        {string("Text", "Hello")->React.string}
      </button>
    })
  })
})

demo(({addDemo: _, addCategory}) => {
  addCategory("Typography", ({addDemo: _, addCategory}) => {
    addCategory("Headings", ({addDemo, addCategory: _}) => {
      addDemo("H1", ({string, int}) =>
        <h1
          style={ReactDOM.Style.make(
            ~fontSize={
              let size = int("Font size", {min: 0, max: 100, initial: 30, step: 1})
              j`$(size)px`
            },
            (),
          )}>
          {string("Text", "hello")->React.string}
        </h1>
      )
      addDemo("H2", ({string}) => <h2> {string("Text", "hello")->React.string} </h2>)
    })

    addCategory("Text", ({addDemo, addCategory: _}) => {
      addDemo("Paragraph", ({string}) => <p> {string("Text", "hello")->React.string} </p>)
      addDemo("Italic", ({string}) => <i> {string("Text", "hello")->React.string} </i>)
    })
  })
})

demo(({addDemo, addCategory: _}) => {
  addDemo("Code example", _propsApi =>
    <code
      style={ReactDOM.Style.make(
        ~whiteSpace="pre",
        ~padding="0",
        ~backgroundColor=ReshowcaseUi__Layout.Color.lightGray,
        (),
      )}>
      {"
demo(({addDemo: _, addCategory}) => {
  addCategory(\"Typography\", ({addDemo: _, addCategory}) => {
    addCategory(\"Headings\", ({addDemo, addCategory: _}) => {
      addDemo(\"H1\", ({string, int}) =>
        <h1
          style={ReactDOM.Style.make(
            ~fontSize={
              let size = int(\"Font size\", {min: 0, max: 100, initial: 30, step: 1})
              j`$(size)px`
            },
            (),
          )}>
          {string(\"Text\", \"hello\")->React.string}
        </h1>
      )
      addDemo(\"H2\", ({string}) => <h2> {string(\"Text\", \"hello\")->React.string} </h2>)
    })

    addCategory(\"Text\", ({addDemo, addCategory: _}) => {
      addDemo(\"Paragraph\", ({string}) => <p> {string(\"Text\", \"hello\")->React.string} </p>)
      addDemo(\"Italic\", ({string}) => <i> {string(\"Text\", \"hello\")->React.string} </i>)
    })
  })
})

start()

"->React.string}
    </code>
  )
})

demo(({addDemo: _, addCategory}) => {
  addCategory("Test search", ({addDemo, addCategory: _}) => {
    addDemo("OneTwoThreeFour", _ => React.null)
    addDemo("OneTwoThreeFive", _ => React.null)
    addDemo("OneTwoFourSeven", _ => React.null)
  })
})

start()
