open Belt;

type demo = {add: (string, unit => list(React.element)) => unit};

let label =
  ReactDOMRe.Style.make(~paddingBottom="10px", ~display="block", ());
let labelText =
  ReactDOMRe.Style.make(~fontSize="10px", ~textTransform="uppercase", ());

let useState = initial => {
  React.useReducer((_ignored, newState) => newState, initial);
};

let makeProp = (sidebarControl, propName, initialValue, continuation) => {
  let (state, setState) = useState(initialValue);
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
      onChange={event => setState(event->ReactEvent.Form.target##checked)}
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
        setState(event->ReactEvent.Form.target##value->int_of_string)
      }
    />
  );
let stringProp =
  makeProp((value, setState) =>
    <input
      type_="text"
      value
      onChange={event => setState(event->ReactEvent.Form.target##value)}
    />
  );

let demos = MutableMap.String.make();

let demo = (demoName, func) => {
  let demoUnits = MutableMap.String.make();
  let demo = {
    add: (demoUnitName, demo) => {
      demoUnits->MutableMap.String.set(demoUnitName, demo);
    },
  };
  func(demo);
  demos->MutableMap.String.set(
    demoName,
    demoUnits->MutableMap.String.toArray->Map.String.fromArray,
  );
};

let start = () => {
  let demos = demos->MutableMap.String.toArray->Map.String.fromArray;
  ReactDOMRe.renderToElementWithId(<ReshowcaseUi.App demos />, "root");
};
