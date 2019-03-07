# Reshowcase

> A tool to create demos for your ReasonReact components

```reason
open Reshowcase;

demo("Title", ({add}) => {
  add("normal", ({string}) =>
    <h1> {string("text", "hello")->ReasonReact.string} </h1>
  );
  add("font-size", ({string, int}) =>
    <h1
      style={ReactDOMRe.Style.make(
        ~fontSize={
          let size =
            int("font size", {min: 0, max: 100, initial: 30, step: 1});
          {j|$(size)px|j};
        },
        (),
      )}>
      {string("text", "hello")->ReasonReact.string}
    </h1>
  );
});

demo("Button", ({add}) =>
  add("normal", ({string, bool}) =>
    <button disabled={bool("disabled", false)}>
      {string("text", "hello")->ReasonReact.string}
    </button>
  )
);

start();
```
