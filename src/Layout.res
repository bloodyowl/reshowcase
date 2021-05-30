module Color = {
  let white = "#fff"
  let lightGray = "#f5f6f6"
  let midGray = "#e0e2e4"
  let darkGray = "#42484d"
  let black40a = "rgba(0, 0, 0, 0.4)"
  let blue = "#0091ff"
  let transparent = "transparent"
}

module Gap = {
  let xs = "7px"
  let md = "10px"
}

module PaddedBox = {
  type padding = Around | LeftRight | TopLeftRight

  module Styles = {
    let around = ReactDOM.Style.make(~padding=Gap.xs, ())
    let leftRight = ReactDOM.Style.make(~padding=`0 ${Gap.xs}`, ())
    let topLeftRight = ReactDOM.Style.make(~padding=`${Gap.xs} ${Gap.xs} 0`, ())

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
    let stack = ReactDOM.Style.make(~display="grid", ~gridGap=Gap.xs, ())
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
