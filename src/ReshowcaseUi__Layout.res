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
  let xxs = "3px"
  let xs = "7px"
  let md = "10px"

  type t = Xxs | Xs | Md

  let getGap = (gap: t) =>
    switch gap {
    | Xxs => xxs
    | Xs => xs
    | Md => md
    }
}

module Border = {
  let default = `1px solid ${Color.midGray}`
}

module PaddedBox = {
  type padding = Around | LeftRight | TopLeftRight

  type border = None | Bottom

  module Styles = {
    let around = gapValue => ReactDOM.Style.make(~padding=gapValue, ())
    let leftRight = gapValue => ReactDOM.Style.make(~padding=`0 ${gapValue}`, ())
    let topLeftRight = gapValue => ReactDOM.Style.make(~padding=`${gapValue} ${gapValue} 0`, ())

    let getPadding = (padding: padding, gap: Gap.t) => {
      let gapValue = Gap.getGap(gap)
      switch padding {
      | Around => around(gapValue)
      | LeftRight => leftRight(gapValue)
      | TopLeftRight => topLeftRight(gapValue)
      }
    }

    let getBorder = (border: border) => {
      switch border {
      | None => ReactDOM.Style.make()
      | Bottom => ReactDOM.Style.make(~borderBottom=Border.default, ())
      }
    }

    let make = (~padding, ~gap, ~border) => {
      let paddingStyles = getPadding(padding, gap)
      let borderStyles = getBorder(border)
      ReactDOM.Style.combine(paddingStyles, borderStyles)
    }
  }

  @react.component
  let make = (~gap: Gap.t=Xs, ~padding: padding=Around, ~border: border=None, ~id=?, ~children) => {
    <div name="PaddedBox" ?id style={Styles.make(~padding, ~border, ~gap)}> children </div>
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
    let width = "230px"

    let sidebar =
      ReactDOM.Style.make(
        ~minWidth=width,
        ~width,
        ~overflowY="auto",
        ~backgroundColor=Color.lightGray,
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch")
  }

  @react.component
  let make = (~innerContainerId=?, ~children=React.null) => {
    <div name="Sidebar" id=?innerContainerId style={Styles.sidebar}> children </div>
  }
}
