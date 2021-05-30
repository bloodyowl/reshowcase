open Belt

module Color = {
  let white = "#fff"
  let lightGray = "#f5f6f6"
  let midGray = "#e0e2e4"
  let darkGray = "#42484d"
  let black40a = "rgba(0, 0, 0, 0.4)"
  let blue = "#0091ff"
  let transparent = "transparent"
}

module PaddedBox = {
  type padding = Around | LeftRight | TopLeftRight

  module Styles = {
    let around = ReactDOM.Style.make(~padding="6px", ())
    let leftRight = ReactDOM.Style.make(~padding="0 6px", ())
    let topLeftRight = ReactDOM.Style.make(~padding="6px 6px 0", ())

    let getPadding = (padding: padding) =>
      switch padding {
      | Around => around
      | LeftRight => leftRight
      | TopLeftRight => topLeftRight
      }
  }

  @react.component
  let make = (~padding: padding=Around, ~children) => {
    <div style={Styles.getPadding(padding)}> children </div>
  }
}

module Stack = {
  module Styles = {
    let stack = ReactDOM.Style.make(~display="grid", ~gridGap="6px", ())
  }

  @react.component
  let make = (~children) => {
    <div style={Styles.stack}> children </div>
  }
}

module Sidebar = {
  module Styles = {
    let sidebar =
      ReactDOM.Style.make(
        ~width="230px",
        ~height="100vh",
        ~overflowY="auto",
        ~backgroundColor=Color.lightGray,
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch")
  }

  @react.component
  let make = (~children) => {
    <div style={Styles.sidebar}> <PaddedBox> children </PaddedBox> </div>
  }
}

module Link = {
  @react.component
  let make = (~href, ~text, ~style=?, ~activeStyle=?) => {
    let url = ReasonReact.Router.useUrl()
    let path = String.concat("/", url.path)
    let isActive = (path ++ ("?" ++ url.search))->Js.String2.endsWith(href)
    <a
      href
      onClick={event =>
        switch (ReactEvent.Mouse.metaKey(event), ReactEvent.Mouse.ctrlKey(event)) {
        | (false, false) =>
          ReactEvent.Mouse.preventDefault(event)
          ReasonReact.Router.push(href)
        | _ => ()
        }}
      style=?{switch (style, activeStyle, isActive) {
      | (Some(style), _, false) => Some(style)
      | (Some(style), None, true) => Some(style)
      | (Some(style), Some(activeStyle), true) => Some(ReactDOM.Style.combine(style, activeStyle))
      | (_, Some(activeStyle), true) => Some(activeStyle)
      | _ => None
      }}>
      {text->React.string}
    </a>
  }
}

module DemoSidebar = {
  module Styles = {
    let demoName = ReactDOM.Style.make(~fontWeight="500", ())
    let link = ReactDOM.Style.make(
      ~textDecoration="none",
      ~color=Color.blue,
      ~display="block",
      ~padding="7px 10px",
      ~borderRadius="7px",
      ~fontWeight="500",
      (),
    )
    let activeLink = ReactDOM.Style.make(~backgroundColor=Color.blue, ~color=Color.white, ())
  }

  module MenuItem = {
    @react.component
    let make = (~demoName, ~demoUnitNames) =>
      <div key=demoName>
        <PaddedBox> <span style=Styles.demoName> {demoName->React.string} </span> </PaddedBox>
        <PaddedBox padding=LeftRight>
          {demoUnitNames
          ->Array.map(demoUnitName =>
            <Link
              key=demoUnitName
              style=Styles.link
              activeStyle=Styles.activeLink
              href={"?demo=" ++
              (demoName->Js.Global.encodeURIComponent ++
              ("&unit=" ++ demoUnitName->Js.Global.encodeURIComponent))}
              text=demoUnitName
            />
          )
          ->React.array}
        </PaddedBox>
      </div>
  }

  module SearchInput = {
    module Styles = {
      let clearButton = ReactDOM.Style.make(
        ~position="absolute",
        ~right="7px",
        ~display="flex",
        ~cursor="pointer",
        ~border="none",
        ~padding="0",
        ~backgroundColor=Color.transparent,
        ~top="50%",
        ~transform="translateY(-50%)",
        ~margin="0",
        (),
      )

      let inputWrapper = ReactDOM.Style.make(
        ~position="relative",
        ~display="flex",
        ~alignItems="center",
        ~backgroundColor=Color.midGray,
        ~borderRadius="7px",
        (),
      )

      let input = ReactDOMRe.Style.make(
        ~padding="7px 10px",
        ~width="100%",
        ~margin="0",
        ~fontFamily="inherit",
        ~fontSize="16px",
        ~border="none",
        ~backgroundColor=Color.transparent,
        ~borderRadius="7px",
        (),
      )
    }

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
        </svg>

      @react.component
      let make = (~onClear) =>
        <button style=Styles.clearButton onClick={_event => onClear()}> iconClose </button>
    }

    @react.component
    let make = (~value, ~onChange, ~onClear) =>
      <PaddedBox padding=TopLeftRight>
        <div style=Styles.inputWrapper>
          <input style=Styles.input placeholder="Filter" value onChange />
          {value === "" ? React.null : <ClearButton onClear />}
        </div>
      </PaddedBox>
  }

  @react.component
  let make = (~demos) => {
    let (filterValue, setFilterValue) = React.useState(() => None)
    <Stack>
      <SearchInput
        value={filterValue->Option.getWithDefault("")}
        onChange={event => {
          let value = (event->ReactEvent.Form.target)["value"]
          setFilterValue(_ => value->Js.String2.trim === "" ? None : Some(value))
        }}
        onClear={() => setFilterValue(_ => None)}
      />
      {demos
      ->Map.String.toArray
      ->Array.keepMap(((demoName, demoUnits)) => {
        let demoUnitNames = demoUnits->Map.String.keysToArray
        switch filterValue {
        | None => Some(<MenuItem key=demoName demoName demoUnitNames />)
        | Some(filterValue) =>
          let search = filterValue->Js.String2.toLowerCase
          let demoNameHasSubstring = demoName->Js.String2.toLowerCase->Js.String2.includes(search)
          let filteredDemoUnitNames =
            demoUnitNames->Array.keep(name =>
              name->Js.String2.toLowerCase->Js.String2.includes(search)
            )
          switch (demoNameHasSubstring, filteredDemoUnitNames) {
          | (false, []) => None
          | (true, []) => Some(<MenuItem key=demoName demoName demoUnitNames />)
          | (true, _)
          | (false, _) =>
            Some(<MenuItem key=demoName demoName demoUnitNames=filteredDemoUnitNames />)
          }
        }
      })
      ->React.array}
    </Stack>
  }
}

module DemoUnitSidebar = {
  module Styles = {
    let label = ReactDOM.Style.make(
      ~display="block",
      ~backgroundColor=Color.white,
      ~borderRadius="7px",
      ~boxShadow="0 5px 10px rgba(0, 0, 0, 0.07)",
      (),
    )
    let labelText = ReactDOM.Style.make(~fontSize="16px", ~textAlign="center", ())
    let textInput = ReactDOM.Style.make(
      ~fontSize="16px",
      ~width="100%",
      ~boxSizing="border-box",
      ~backgroundColor=Color.lightGray,
      ~boxShadow="inset 0 0 0 1px rgba(0, 0, 0, 0.1)",
      ~border="none",
      ~padding="10px",
      ~borderRadius="7px",
      (),
    )
    let select =
      ReactDOM.Style.make(
        ~fontSize="16px",
        ~width="100%",
        ~boxSizing="border-box",
        ~backgroundColor=Color.lightGray,
        ~boxShadow="inset 0 0 0 1px rgba(0, 0, 0, 0.1)",
        ~border="none",
        ~padding="10px",
        ~borderRadius="7px",
        ~appearance="none",
        ~paddingRight="30px",
        ~backgroundImage=`url("data:image/svg+xml,%3Csvg width='36' height='36' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath stroke='%2342484E' stroke-width='2' d='M12.246 14.847l5.826 5.826 5.827-5.826' fill='none' fill-rule='evenodd' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E")`,
        ~backgroundPosition="center right",
        ~backgroundSize="contain",
        ~backgroundRepeat="no-repeat",
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitAppearance", "none")
    let checkbox = ReactDOM.Style.make(~fontSize="16px", ~margin="0 auto", ~display="block", ())
  }

  module PropBox = {
    @react.component
    let make = (~propName: string, ~children) => {
      <label style=Styles.label>
        <PaddedBox>
          <Stack> <div style=Styles.labelText> {propName->React.string} </div> children </Stack>
        </PaddedBox>
      </label>
    }
  }

  @react.component
  let make = (
    ~strings: Map.String.t<(Configs.stringConfig, string, option<array<(string, string)>>)>,
    ~ints: Map.String.t<(Configs.numberConfig<int>, int)>,
    ~floats: Map.String.t<(Configs.numberConfig<float>, float)>,
    ~bools: Map.String.t<(Configs.boolConfig, bool)>,
    ~onStringChange,
    ~onIntChange,
    ~onFloatChange,
    ~onBoolChange,
    _,
  ) =>
    <Stack>
      {strings
      ->Map.String.toArray
      ->Array.map(((propName, (_config, value, options))) =>
        <PropBox key=propName propName>
          {switch options {
          | None =>
            <input
              type_="text"
              value
              style=Styles.textInput
              onChange={event => onStringChange(propName, (event->ReactEvent.Form.target)["value"])}
            />
          | Some(options) =>
            <select
              style=Styles.select
              onChange={event => {
                let value = (event->ReactEvent.Form.target)["value"]
                onStringChange(propName, value)
              }}>
              {options
              ->Array.map(((key, optionValue)) => {
                <option key selected={value == optionValue} value={optionValue}>
                  {key->React.string}
                </option>
              })
              ->React.array}
            </select>
          }}
        </PropBox>
      )
      ->React.array}
      {ints
      ->Map.String.toArray
      ->Array.map(((propName, ({min, max}, value))) =>
        <PropBox key=propName propName>
          <input
            type_="number"
            min=j`$min`
            max=j`$max`
            value=j`$value`
            style=Styles.textInput
            onChange={event =>
              onIntChange(propName, (event->ReactEvent.Form.target)["value"]->int_of_string)}
          />
        </PropBox>
      )
      ->React.array}
      {floats
      ->Map.String.toArray
      ->Array.map(((propName, ({min, max}, value))) =>
        <PropBox key=propName propName>
          <input
            type_="number"
            min=j`$min`
            max=j`$max`
            value=j`$value`
            style=Styles.textInput
            onChange={event =>
              onFloatChange(propName, (event->ReactEvent.Form.target)["value"]->float_of_string)}
          />
        </PropBox>
      )
      ->React.array}
      {bools
      ->Map.String.toArray
      ->Array.map(((propName, (_config, checked))) =>
        <PropBox key=propName propName>
          <input
            type_="checkbox"
            checked
            style=Styles.checkbox
            onChange={event => onBoolChange(propName, (event->ReactEvent.Form.target)["checked"])}
          />
        </PropBox>
      )
      ->React.array}
    </Stack>
}

module DemoUnit = {
  type state = {
    strings: Map.String.t<(Configs.stringConfig, string, option<array<(string, string)>>)>,
    ints: Map.String.t<(Configs.numberConfig<int>, int)>,
    floats: Map.String.t<(Configs.numberConfig<float>, float)>,
    bools: Map.String.t<(Configs.boolConfig, bool)>,
  }

  type action =
    | SetString(string, string)
    | SetInt(string, int)
    | SetFloat(string, float)
    | SetBool(string, bool)

  module Styles = {
    let container = ReactDOM.Style.make(
      ~flexGrow="1",
      ~display="flex",
      ~alignItems="stretch",
      ~flexDirection="row",
      (),
    )
    let contents =
      ReactDOM.Style.make(
        ~height="100vh",
        ~flexGrow="1",
        ~overflowY="auto",
        ~display="flex",
        ~flexDirection="column",
        ~alignItems="center",
        ~justifyContent="center",
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch")
  }

  @react.component
  let make = (~demoUnit: Configs.demoUnit => React.element) => {
    let (state, dispatch) = React.useReducer(
      (state, action) =>
        switch action {
        | SetString(name, newValue) => {
            ...state,
            strings: state.strings->Map.String.update(name, value =>
              value->Option.map(((config, _value, options)) => (config, newValue, options))
            ),
          }
        | SetInt(name, newValue) => {
            ...state,
            ints: state.ints->Map.String.update(name, value =>
              value->Option.map(((config, _value)) => (config, newValue))
            ),
          }
        | SetFloat(name, newValue) => {
            ...state,
            floats: state.floats->Map.String.update(name, value =>
              value->Option.map(((config, _value)) => (config, newValue))
            ),
          }
        | SetBool(name, newValue) => {
            ...state,
            bools: state.bools->Map.String.update(name, value =>
              value->Option.map(((config, _value)) => (config, newValue))
            ),
          }
        },
      {
        let strings = ref(Map.String.empty)
        let ints = ref(Map.String.empty)
        let floats = ref(Map.String.empty)
        let bools = ref(Map.String.empty)
        let props: Configs.demoUnit = {
          string: (name, ~options=?, config) => {
            strings := strings.contents->Map.String.set(name, (config, config, options))
            config
          },
          int: (name, config) => {
            ints := ints.contents->Map.String.set(name, (config, config.initial))
            config.initial
          },
          float: (name, config) => {
            floats := floats.contents->Map.String.set(name, (config, config.initial))
            config.initial
          },
          bool: (name, config) => {
            bools := bools.contents->Map.String.set(name, (config, config))
            config
          },
        }
        let _ = demoUnit(props)
        {
          strings: strings.contents,
          ints: ints.contents,
          floats: floats.contents,
          bools: bools.contents,
        }
      },
    )
    let props: Configs.demoUnit = {
      string: (name, ~options as _=?, _config) => {
        let (_, value, _) = state.strings->Map.String.getExn(name)
        value
      },
      int: (name, _config) => {
        let (_, value) = state.ints->Map.String.getExn(name)
        value
      },
      float: (name, _config) => {
        let (_, value) = state.floats->Map.String.getExn(name)
        value
      },
      bool: (name, _config) => {
        let (_, value) = state.bools->Map.String.getExn(name)
        value
      },
    }
    <div style=Styles.container>
      <div style=Styles.contents> {demoUnit(props)} </div>
      <Sidebar>
        <DemoUnitSidebar
          strings=state.strings
          ints=state.ints
          floats=state.floats
          bools=state.bools
          onStringChange={(name, value) => dispatch(SetString(name, value))}
          onIntChange={(name, value) => dispatch(SetInt(name, value))}
          onFloatChange={(name, value) => dispatch(SetFloat(name, value))}
          onBoolChange={(name, value) => dispatch(SetBool(name, value))}
        />
      </Sidebar>
    </div>
  }
}

module DemoUnitFrame = {
  @react.component
  let make = (~demoName=?, ~demoUnitName=?, _) =>
    <iframe
      src={switch (demoName, demoUnitName) {
      | (Some(demo), Some(unit)) => j`?iframe=true&demo=$demo&unit=$unit`
      | _ => "?iframe=true"
      }}
      style={ReactDOM.Style.make(~height="100vh", ~width="100%", ~border="none", ())}
    />
}

module App = {
  module Styles = {
    let app = ReactDOM.Style.make(
      ~display="flex",
      ~flexDirection="row",
      ~minHeight="100vh",
      ~alignItems="stretch",
      ~color=Color.darkGray,
      (),
    )
    let main = ReactDOM.Style.make(~flexGrow="1", ~display="flex", ~flexDirection="column", ())
    let empty = ReactDOM.Style.make(
      ~flexGrow="1",
      ~display="flex",
      ~flexDirection="column",
      ~alignItems="center",
      ~justifyContent="center",
      (),
    )
    let emptyText = ReactDOM.Style.make(
      ~fontSize="22px",
      ~color=Color.black40a,
      ~textAlign="center",
      (),
    )
  }
  type route =
    | Unit(string, string)
    | Demo(string, string)
    | Home
  type urlSearchParams
  @new
  external urlSearchParams: string => urlSearchParams = "URLSearchParams"
  @return(nullable) @bs.send
  external get: (urlSearchParams, string) => option<string> = "get"

  @react.component
  let make = (~demos) => {
    let url = ReasonReact.Router.useUrl()
    let queryString = url.search->urlSearchParams
    let route = switch (
      queryString->get("iframe"),
      queryString->get("demo"),
      queryString->get("unit"),
    ) {
    | (Some("true"), Some(demo), Some(unit)) => Unit(demo, unit)
    | (_, Some(demo), Some(unit)) => Demo(demo, unit)
    | _ => Home
    }
    <div style=Styles.app>
      {switch route {
      | Unit(demoName, demoUnitName) =>
        <div style=Styles.main>
          {demos
          ->Map.String.get(demoName)
          ->Option.flatMap(demo => demo->Map.String.get(demoUnitName))
          ->Option.map(demoUnit => <DemoUnit demoUnit key={demoName ++ ("$$" ++ demoUnitName)} />)
          ->Option.getWithDefault(React.null)}
        </div>
      | Demo(demoName, demoUnitName) => <>
          <Sidebar> <DemoSidebar demos /> </Sidebar>
          <div style=Styles.main> <DemoUnitFrame demoName demoUnitName /> </div>
        </>
      | Home => <>
          <Sidebar> <DemoSidebar demos /> </Sidebar>
          <div style=Styles.main>
            <div style=Styles.empty>
              <div style=Styles.emptyText> {"Pick a demo"->React.string} </div>
            </div>
          </div>
        </>
      }}
    </div>
  }
}
