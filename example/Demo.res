open Entry

demo("Title", ({add}) => {
  add("Normal", ({string}) => <h1> {string("Text", "hello")->React.string} </h1>)
  add("Font size", ({string, int}) =>
    <h1
      style={ReactDOMRe.Style.make(
        ~fontSize={
          let size = int("Font size", {min: 0, max: 100, initial: 30, step: 1})
          j`$(size)px`
        },
        (),
      )}>
      {string("Text", "hello")->React.string}
    </h1>
  )
})

demo("Button", ({add}) =>
  add("Normal", ({string, bool}) => {
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
)

start()
