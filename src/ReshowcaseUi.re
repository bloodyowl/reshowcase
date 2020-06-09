open Belt;

module Link = {
  [@react.component]
  let make = (~href, ~text, ~style=?, ~activeStyle=?) => {
    let url = ReasonReact.Router.useUrl();
    let path = "/" ++ String.concat("/", url.path);
    let isActive = path === href;
    <a
      href
      onClick={event =>
        switch (
          ReactEvent.Mouse.metaKey(event),
          ReactEvent.Mouse.ctrlKey(event),
        ) {
        | (false, false) =>
          ReactEvent.Mouse.preventDefault(event);
          ReasonReact.Router.push(href);
        | _ => ()
        }
      }
      style=?{
        switch (style, activeStyle, isActive) {
        | (Some(style), _, false) => Some(style)
        | (Some(style), None, true) => Some(style)
        | (Some(style), Some(activeStyle), true) =>
          Some(ReactDOMRe.Style.combine(style, activeStyle))
        | (_, Some(activeStyle), true) => Some(activeStyle)
        | _ => None
        }
      }>
      text->React.string
    </a>;
  };
};

module DemoSidebar = {
  module Styles = {
    let container =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~backgroundColor="#F4F7F8",
        ~overflowY="auto",
        (),
      )
      ->ReactDOMRe.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let subList = ReactDOMRe.Style.make(~fontSize="14px", ());
    let demoName =
      ReactDOMRe.Style.make(
        ~fontSize="14px",
        ~fontWeight="700",
        ~padding="10px",
        (),
      );
    let link =
      ReactDOMRe.Style.make(
        ~textDecoration="none",
        ~color="#195EAE",
        ~display="block",
        ~padding="5px 10px",
        (),
      );
    let activeLink =
      ReactDOMRe.Style.make(
        ~fontWeight="700",
        ~backgroundColor="#195EAE",
        ~color="#fff",
        (),
      );
  };
  [@react.component]
  let make = (~demos) => {
    <div style=Styles.container>
      <div>
        {demos
         ->Map.String.toArray
         ->Array.map(((demoName, demoUnits)) =>
             <div key=demoName>
               <div style=Styles.demoName> demoName->React.string </div>
               <div style=Styles.subList>
                 {demoUnits
                  ->Map.String.keysToArray
                  ->Array.map(demoUnitName =>
                      <div key=demoUnitName>
                        <Link
                          style=Styles.link
                          activeStyle=Styles.activeLink
                          href={"/" ++ demoName ++ "/" ++ demoUnitName}
                          text=demoUnitName
                        />
                      </div>
                    )
                  ->React.array}
               </div>
             </div>
           )
         ->React.array}
      </div>
    </div>;
  };
};

module DemoUnitSidebar = {
  module Styles = {
    let container =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~backgroundColor="#F4F7F8",
        ~fontSize="14px",
        ~padding="10px",
        ~overflowY="auto",
        (),
      )
      ->ReactDOMRe.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let label =
      ReactDOMRe.Style.make(~paddingBottom="10px", ~display="block", ());
    let labelText =
      ReactDOMRe.Style.make(~fontSize="10px", ~textTransform="uppercase", ());
  };
  [@react.component]
  let make =
      (
        ~strings: Map.String.t((Configs.stringConfig, string)),
        ~ints: Map.String.t((Configs.numberConfig(int), int)),
        ~floats: Map.String.t((Configs.numberConfig(float), float)),
        ~bools: Map.String.t((Configs.boolConfig, bool)),
        ~onStringChange,
        ~onIntChange,
        ~onFloatChange,
        ~onBoolChange,
        _,
      ) =>
    <div style=Styles.container>
      {strings
       ->Map.String.toArray
       ->Array.map(((propName, (_config, value))) =>
           <label key=propName style=Styles.label>
             <div style=Styles.labelText> propName->React.string </div>
             <input
               type_="text"
               value
               onChange={event =>
                 onStringChange(
                   propName,
                   event->ReactEvent.Form.target##value,
                 )
               }
             />
           </label>
         )
       ->React.array}
      {ints
       ->Map.String.toArray
       ->Array.map(((propName, ({min, max}, value))) =>
           <label key=propName style=Styles.label>
             <div style=Styles.labelText> propName->React.string </div>
             <input
               type_="number"
               min={j|$min|j}
               max={j|$max|j}
               value={j|$value|j}
               onChange={event =>
                 onIntChange(
                   propName,
                   event->ReactEvent.Form.target##value->int_of_string,
                 )
               }
             />
           </label>
         )
       ->React.array}
      {floats
       ->Map.String.toArray
       ->Array.map(((propName, ({min, max}, value))) =>
           <label key=propName style=Styles.label>
             <div style=Styles.labelText> propName->React.string </div>
             <input
               type_="number"
               min={j|$min|j}
               max={j|$max|j}
               value={j|$value|j}
               onChange={event =>
                 onFloatChange(
                   propName,
                   event->ReactEvent.Form.target##value->float_of_string,
                 )
               }
             />
           </label>
         )
       ->React.array}
      {bools
       ->Map.String.toArray
       ->Array.map(((propName, (_config, checked))) =>
           <label key=propName style=Styles.label>
             <div style=Styles.labelText> propName->React.string </div>
             <input
               type_="checkbox"
               checked
               onChange={event =>
                 onBoolChange(
                   propName,
                   event->ReactEvent.Form.target##checked,
                 )
               }
             />
           </label>
         )
       ->React.array}
    </div>;
};

module DemoUnit = {
  type state = {
    strings: Map.String.t((Configs.stringConfig, string)),
    ints: Map.String.t((Configs.numberConfig(int), int)),
    floats: Map.String.t((Configs.numberConfig(float), float)),
    bools: Map.String.t((Configs.boolConfig, bool)),
  };

  type action =
    | SetString(string, string)
    | SetInt(string, int)
    | SetFloat(string, float)
    | SetBool(string, bool);

  module Styles = {
    let container =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~alignItems="stretch",
        ~flexDirection="row",
        (),
      );
    let contents =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~padding="10px",
        ~overflowY="auto",
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      )
      ->ReactDOMRe.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let sidebar =
      ReactDOMRe.Style.make(
        ~width="200px",
        ~display="flex",
        ~flexDirection="column",
        (),
      );
  };

  [@react.component]
  let make = (~demoUnit: Configs.demoUnit => React.element) => {
    let (state, dispatch) =
      React.useReducer(
        (state, action) =>
          switch (action) {
          | SetString(name, newValue) => {
              ...state,
              strings:
                state.strings
                ->Map.String.update(name, value =>
                    value->Option.map(((config, _value)) =>
                      (config, newValue)
                    )
                  ),
            }
          | SetInt(name, newValue) => {
              ...state,
              ints:
                state.ints
                ->Map.String.update(name, value =>
                    value->Option.map(((config, _value)) =>
                      (config, newValue)
                    )
                  ),
            }
          | SetFloat(name, newValue) => {
              ...state,
              floats:
                state.floats
                ->Map.String.update(name, value =>
                    value->Option.map(((config, _value)) =>
                      (config, newValue)
                    )
                  ),
            }
          | SetBool(name, newValue) => {
              ...state,
              bools:
                state.bools
                ->Map.String.update(name, value =>
                    value->Option.map(((config, _value)) =>
                      (config, newValue)
                    )
                  ),
            }
          },
        {
          let strings = ref(Map.String.empty);
          let ints = ref(Map.String.empty);
          let floats = ref(Map.String.empty);
          let bools = ref(Map.String.empty);
          let props: Configs.demoUnit = {
            string: (name, config) => {
              strings := (strings^)->Map.String.set(name, (config, config));
              config;
            },
            int: (name, config) => {
              ints := (ints^)->Map.String.set(name, (config, config.initial));
              config.initial;
            },
            float: (name, config) => {
              floats :=
                (floats^)->Map.String.set(name, (config, config.initial));
              config.initial;
            },
            bool: (name, config) => {
              bools := (bools^)->Map.String.set(name, (config, config));
              config;
            },
          };
          let _ = demoUnit(props);
          {strings: strings^, ints: ints^, floats: floats^, bools: bools^};
        },
      );
    let props: Configs.demoUnit = {
      string: (name, _config) => {
        let (_, value) = state.strings->Map.String.getExn(name);
        value;
      },
      int: (name, _config) => {
        let (_, value) = state.ints->Map.String.getExn(name);
        value;
      },
      float: (name, _config) => {
        let (_, value) = state.floats->Map.String.getExn(name);
        value;
      },
      bool: (name, _config) => {
        let (_, value) = state.bools->Map.String.getExn(name);
        value;
      },
    };
    <div style=Styles.container>
      <div style=Styles.contents> {demoUnit(props)} </div>
      <div style=Styles.sidebar>
        <DemoUnitSidebar
          strings={state.strings}
          ints={state.ints}
          floats={state.floats}
          bools={state.bools}
          onStringChange={(name, value) => dispatch(SetString(name, value))}
          onIntChange={(name, value) => dispatch(SetInt(name, value))}
          onFloatChange={(name, value) => dispatch(SetFloat(name, value))}
          onBoolChange={(name, value) => dispatch(SetBool(name, value))}
        />
      </div>
    </div>;
  };
};

module DemoUnitFrame = {
  [@react.component]
  let make = (~demoName, ~demoUnitName, _) =>
    <iframe
      src={j|/unit/$demoName/$demoUnitName|j}
      style={ReactDOMRe.Style.make(
        ~height="100vh",
        ~width="100%",
        ~border="none",
        (),
      )}
    />;
};

module App = {
  module Styles = {
    let app =
      ReactDOMRe.Style.make(
        ~display="flex",
        ~flexDirection="row",
        ~minHeight="100vh",
        ~alignItems="stretch",
        (),
      );
    let navigation =
      ReactDOMRe.Style.make(
        ~width="200px",
        ~display="flex",
        ~flexDirection="column",
        (),
      );
    let main =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~flexDirection="column",
        (),
      );
    let empty =
      ReactDOMRe.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      );
    let emptyText =
      ReactDOMRe.Style.make(
        ~fontSize="22px",
        ~color="rgba(0, 0, 0, 0.4)",
        ~textAlign="center",
        (),
      );
  };
  [@react.component]
  let make = (~demos) => {
    let url = ReasonReact.Router.useUrl();
    <div style=Styles.app>
      {switch (url.path) {
       | ["unit", demoName, demoUnitName] =>
         <div style=Styles.main>
           {demos
            ->Map.String.get(demoName)
            ->Option.flatMap(demo => demo->Map.String.get(demoUnitName))
            ->Option.map(demoUnit =>
                <DemoUnit demoUnit key={demoName ++ "$$" ++ demoUnitName} />
              )
            ->Option.getWithDefault(React.null)}
         </div>
       | [demoName, demoUnitName] =>
         <>
           <div style=Styles.navigation> <DemoSidebar demos /> </div>
           <div style=Styles.main>
             <DemoUnitFrame demoName demoUnitName />
           </div>
         </>
       | _ =>
         <>
           <div style=Styles.navigation> <DemoSidebar demos /> </div>
           <div style=Styles.main>
             <div style=Styles.empty>
               <div style=Styles.emptyText> "Pick a demo"->React.string </div>
             </div>
           </div>
         </>
       }}
    </div>;
  };
};
