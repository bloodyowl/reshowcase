open Belt;

type demo = {add: (string, unit => list(React.element)) => unit};

let label =
  ReactDOMRe.Style.make(~paddingBottom="10px", ~display="block", ());
let labelText =
  ReactDOMRe.Style.make(~fontSize="10px", ~textTransform="uppercase", ());

let makeProp = (sidebarControl, propName, initialValue, continuation) => {
  Js.log2("make", propName);
  let (state, setState) = React.useState(() => initialValue);
  [
    <label key=propName style=label>
      <div style=labelText> propName->React.string </div>
      {sidebarControl(state, setState)}
    </label>,
    ...continuation(state),
  ];
};
let boolProp =
  makeProp((checked, setState) =>
    <input
      type_="checkbox"
      checked
      onChange={event => setState(_ => event->ReactEvent.Form.target##checked)}
    />
  );
let intProp =
  makeProp((state, setState) =>
    <input
      type_="number"
      min=0
      max="100"
      value={state->Int.toString}
      onChange={event =>
        setState(_ => event->ReactEvent.Form.target##value->int_of_string)
      }
    />
  );
let stringProp =
  makeProp((value, setState) =>
    <input
      type_="text"
      value
      onChange={event => setState(_ => event->ReactEvent.Form.target##value)}
    />
  );

let v = () => {
  intProp("font size", 2, size =>
    stringProp("text", "hello", text =>
      [
        <h1 style={ReactDOMRe.Style.make(~fontSize=size->Int.toString, ())}>
          text->React.string
        </h1>,
      ]
    )
  );
};
let u = v();

let t = ({add}) => {
  add("font-size", () =>
    intProp("font size", 2, size =>
      stringProp("text", "hello", text =>
        [
          <h1 style={ReactDOMRe.Style.make(~fontSize=size->Int.toString, ())}>
            text->React.string
          </h1>,
        ]
      )
    )
  );
  add("normal", () =>
    stringProp("text", "hello", text => [<h1> text->React.string </h1>])
  );
};
