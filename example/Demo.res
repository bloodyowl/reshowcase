open Entry

// demo("Title", ({add}) => {
//   add("Normal", ({string}) => <h1> {string("Text", "hello")->React.string} </h1>)
//   add("Font size", ({string, int}) =>
//     <h1
//       style={ReactDOMRe.Style.make(
//         ~fontSize={
//           let size = int("Font size", {min: 0, max: 100, initial: 30, step: 1})
//           j`$(size)px`
//         },
//         (),
//       )}>
//       {string("Text", "hello")->React.string}
//     </h1>
//   )
// })

// demo("Button", ({add}) =>
//   add("Normal", ({string, bool}) => {
//     let disabled = bool("Disabled", false)
//     <button
//       disabled
//       style={ReactDOM.Style.make(
//         ~backgroundColor=string(
//           "Color",
//           ~options=[("Red", "#E02020"), ("Green", "#6DD400"), ("Blue", "#0091FF")],
//           "#0091FF",
//         ),
//         ~color="#fff",
//         ~border="none",
//         ~padding="10px",
//         ~borderRadius="10px",
//         ~fontFamily="inherit",
//         ~fontSize="inherit",
//         ~opacity=disabled ? "0.5" : "1",
//         ~cursor=disabled ? "default" : "pointer",
//         (),
//       )}>
//       {string("Text", "hello")->React.string}
//     </button>
//   })
// )

demo(({addDemo, addCategory}) => {
  addDemo("First demo", _propsApi => <p> {"LALA element"->React.string} </p>)

  addCategory("Headings big", ({addDemo, addCategory}) => {
    addDemo("H1 foo", _propsApi => <h1> {"H1"->React.string} </h1>)
    addDemo("H2 bar", _propsApi => <h2> {"H2"->React.string} </h2>)

    addCategory("Headings small", ({addDemo, addCategory}) => {
      addDemo("H11 foo", _propsApi => <h1> {"H1"->React.string} </h1>)
      addDemo("H22 bar", _propsApi => <h2> {"H2"->React.string} </h2>)

      addCategory("Headings1", ({addDemo, addCategory}) => {
        addDemo("H1 mid", _propsApi => <h1> {"H1"->React.string} </h1>)
        addDemo("H2 mid", _propsApi => <h2> {"H2"->React.string} </h2>)

        addCategory("Headings2", ({addDemo, addCategory: _}) => {
          addDemo("H11 last", _propsApi => <h1> {"H1"->React.string} </h1>)
          addDemo("H22 last", _propsApi => <h2> {"H2"->React.string} </h2>)
        })
      })
    })
  })
})

start()
