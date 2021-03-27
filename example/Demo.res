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
  add("Normal", ({string, bool}) =>
    <button disabled={bool("Disabled", false)}> {string("Text", "hello")->React.string} </button>
  )
)

start()
