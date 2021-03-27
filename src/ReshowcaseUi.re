open Belt;

module Link = {
  [@react.component]
  let make = (~href, ~text, ~style=?, ~activeStyle=?) => {
    let url = ReasonReact.Router.useUrl();
    let path = "/" ++ String.concat("/", url.path);
    let isActive = path ++ "?" ++ url.search === href;
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
          Some(ReactDOM.Style.combine(style, activeStyle))
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
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~backgroundColor="#F5F6F6",
        ~overflowY="auto",
        (),
      )
      ->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let subList = ReactDOM.Style.make(~fontSize="16px", ());
    let demoName =
      ReactDOM.Style.make(
        ~fontSize="18px",
        ~fontWeight="700",
        ~padding="10px",
        ~margin="10px 10px 0",
        (),
      );
    let link =
      ReactDOM.Style.make(
        ~textDecoration="none",
        ~color="#0091FF",
        ~display="block",
        ~padding="7px 10px",
        ~margin="0 10px",
        ~borderRadius="7px",
        (),
      );
    let activeLink =
      ReactDOM.Style.make(~backgroundColor="#0091FF", ~color="#fff", ());
  };

  module MenuItem = {
    [@react.component]
    let make = (~demoName, ~demoUnitNames) =>
      <div key=demoName>
        <div style=Styles.demoName> demoName->React.string </div>
        <div style=Styles.subList>
          {demoUnitNames
           ->Array.map(demoUnitName =>
               <div key=demoUnitName>
                 <Link
                   style=Styles.link
                   activeStyle=Styles.activeLink
                   href={
                     "/?demo="
                     ++ demoName->Js.Global.encodeURIComponent
                     ++ "&unit="
                     ++ demoUnitName->Js.Global.encodeURIComponent
                   }
                   text=demoUnitName
                 />
               </div>
             )
           ->React.array}
        </div>
      </div>;
  };

  module SearchInput = {
    module Styles = {
      let buttonClear =
        ReactDOM.Style.make(
          ~position="absolute",
          ~right="7px",
          ~display="flex",
          ~cursor="pointer",
          ~border="none",
          ~padding="0",
          ~backgroundColor="transparent",
          ~top="50%",
          ~transform="translateY(-50%)",
          ~margin="0",
          (),
        );

      let inputWrapper =
        ReactDOM.Style.make(
          ~position="relative",
          ~display="flex",
          ~alignItems="center",
          ~backgroundColor="#E0E2E4",
          ~borderRadius="7px",
          ~margin="10px",
          (),
        );

      let input =
        ReactDOMRe.Style.make(
          ~padding="7px 10px",
          ~width="100%",
          ~margin="0",
          ~fontFamily="inherit",
          ~fontSize="16px",
          ~border="none",
          ~backgroundColor="transparent",
          ~borderRadius="7px",
          (),
        );
    };

    module ClearButton = {
      let iconClose =
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="18"
          height="18"
          viewBox="0 0 18 18"
          style={ReactDOM.Style.make(~display="block", ())}>
          <path
            fill="gray"
            d="M14.53 4.53l-1.06-1.06L9 7.94 4.53 3.47 3.47 4.53 7.94 9l-4.47 4.47 1.06 1.06L9 10.06l4.47 4.47 1.06-1.06L10.06 9z"
          />
        </svg>;

      [@react.component]
      let make = (~onClear) =>
        <button style=Styles.buttonClear onClick={_event => onClear()}>
          iconClose
        </button>;
    };

    [@react.component]
    let make = (~value, ~onChange, ~onClear) =>
      <div style=Styles.inputWrapper>
        <input style=Styles.input placeholder="Filter" value onChange />
        {value === "" ? React.null : <ClearButton onClear />}
      </div>;
  };

  [@react.component]
  let make = (~demos) => {
    let (filterValue, setFilterValue) = React.useState(() => None);

    <div style=Styles.container>
      <div>
        <SearchInput
          value={filterValue->Option.getWithDefault("")}
          onChange={event => {
            let value = event->ReactEvent.Form.target##value;
            setFilterValue(_ =>
              value->Js.String2.trim === "" ? None : Some(value)
            );
          }}
          onClear={() => setFilterValue(_ => None)}
        />
        {demos
         ->Map.String.toArray
         ->Array.keepMap(((demoName, demoUnits)) => {
             let demoUnitNames = demoUnits->Map.String.keysToArray;
             switch (filterValue) {
             | None => Some(<MenuItem key=demoName demoName demoUnitNames />)
             | Some(filterValue) =>
               let search = filterValue->Js.String2.toLowerCase;
               let demoNameHasSubstring =
                 demoName
                 ->Js.String2.toLowerCase
                 ->Js.String2.includes(search);
               let filteredDemoUnitNames =
                 demoUnitNames->Array.keep(name =>
                   name->Js.String2.toLowerCase->Js.String2.includes(search)
                 );
               switch (demoNameHasSubstring, filteredDemoUnitNames) {
               | (false, [||]) => None
               | (true, [||]) =>
                 Some(<MenuItem key=demoName demoName demoUnitNames />)
               | (true, _)
               | (false, _) =>
                 Some(
                   <MenuItem
                     key=demoName
                     demoName
                     demoUnitNames=filteredDemoUnitNames
                   />,
                 )
               };
             };
           })
         ->React.array}
      </div>
    </div>;
  };
};

module DemoUnitSidebar = {
  module Styles = {
    let container =
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~backgroundColor="#F5F6F6",
        ~fontSize="16px",
        ~padding="10px",
        ~overflowY="auto",
        (),
      )
      ->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let label =
      ReactDOM.Style.make(
        ~display="block",
        ~margin="10px",
        ~padding="10px",
        ~backgroundColor="#fff",
        ~borderRadius="7px",
        ~boxShadow="0 5px 10px rgba(0, 0, 0, 0.07)",
        (),
      );
    let labelText =
      ReactDOM.Style.make(
        ~fontSize="16px",
        ~textAlign="center",
        ~paddingBottom="10px",
        (),
      );
    let textInput =
      ReactDOM.Style.make(
        ~fontSize="16px",
        ~width="100%",
        ~boxSizing="border-box",
        ~backgroundColor="#f5f6f6",
        ~boxShadow="inset 0 0 0 1px rgba(0, 0, 0, 0.1)",
        ~border="none",
        ~padding="10px",
        ~borderRadius="7px",
        (),
      );
    let checkbox =
      ReactDOM.Style.make(
        ~fontSize="16px",
        ~margin="0 auto",
        ~display="block",
        (),
      );
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
               style=Styles.textInput
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
               style=Styles.textInput
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
               style=Styles.textInput
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
               style=Styles.checkbox
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
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~alignItems="stretch",
        ~flexDirection="row",
        (),
      );
    let contents =
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~padding="10px",
        ~overflowY="auto",
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      )
      ->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch");
    let sidebar =
      ReactDOM.Style.make(
        ~width="230px",
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
  let make = (~demoName=?, ~demoUnitName=?, _) =>
    <iframe
      src={
        switch (demoName, demoUnitName) {
        | (Some(demo), Some(unit)) => {j|/unit?demo=$demo&unit=$unit|j}
        | _ => "/unit"
        }
      }
      style={ReactDOM.Style.make(
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
      ReactDOM.Style.make(
        ~display="flex",
        ~flexDirection="row",
        ~minHeight="100vh",
        ~alignItems="stretch",
        ~color="#42484D",
        (),
      );
    let navigation =
      ReactDOM.Style.make(
        ~width="230px",
        ~display="flex",
        ~flexDirection="column",
        (),
      );
    let main =
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~flexDirection="column",
        (),
      );
    let empty =
      ReactDOM.Style.make(
        ~flexGrow="1",
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      );
    let emptyText =
      ReactDOM.Style.make(
        ~fontSize="22px",
        ~color="rgba(0, 0, 0, 0.4)",
        ~textAlign="center",
        (),
      );
  };
  type route =
    | Unit(string, string)
    | Demo(string, string)
    | Home;
  type urlSearchParams;
  [@bs.new]
  external urlSearchParams: string => urlSearchParams = "URLSearchParams";
  [@bs.return nullable] [@bs.send]
  external get: (urlSearchParams, string) => option(string) = "get";

  [@react.component]
  let make = (~demos) => {
    let url = ReasonReact.Router.useUrl();
    let queryString = url.search->urlSearchParams;
    let route =
      switch (url.path, queryString->get("demo"), queryString->get("unit")) {
      | (["unit"], Some(demo), Some(unit)) => Unit(demo, unit)
      | ([], Some(demo), Some(unit)) => Demo(demo, unit)
      | _ => Home
      };
    <div style=Styles.app>
      {switch (route) {
       | Unit(demoName, demoUnitName) =>
         <div style=Styles.main>
           {demos
            ->Map.String.get(demoName)
            ->Option.flatMap(demo => demo->Map.String.get(demoUnitName))
            ->Option.map(demoUnit =>
                <DemoUnit demoUnit key={demoName ++ "$$" ++ demoUnitName} />
              )
            ->Option.getWithDefault(React.null)}
         </div>
       | Demo(demoName, demoUnitName) =>
         <>
           <div style=Styles.navigation> <DemoSidebar demos /> </div>
           <div style=Styles.main>
             <DemoUnitFrame demoName demoUnitName />
           </div>
         </>
       | Home =>
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
