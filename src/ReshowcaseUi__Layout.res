module Color = {
  let white = "#fff"
  let lightGray = "#f5f6f6"
  let midGray = "#e0e2e4"
  let darkGray = "#42484d"
  let black40a = "rgba(0, 0, 0, 0.4)"
  let blue = "#0091ff"
  let orange = "#ffae4b"
  let transparent = "transparent"
}

module Gap = {
  let xxs = "2px"
  let xs = "5px"
  let md = "8px"

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

module BorderRadius = {
  let default = "5px"
}

module FontSize = {
  let sm = "12px"
  let md = "14px"
  let lg = "20px"
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
    <div name="Stack" style={Styles.stack}> children </div>
  }
}

module Sidebar = {
  module Styles = {
    let width = "230px"

    let sidebar = (~fullHeight) =>
      ReactDOM.Style.make(
        ~minWidth=width,
        ~width,
        ~height={fullHeight ? "100vh" : "auto"},
        ~overflowY="auto",
        ~backgroundColor=Color.lightGray,
        (),
      )->ReactDOM.Style.unsafeAddProp("WebkitOverflowScrolling", "touch")
  }

  @react.component
  let make = (~innerContainerId=?, ~fullHeight=false, ~children=React.null) => {
    <div name="Sidebar" id=?innerContainerId style={Styles.sidebar(~fullHeight)}> children </div>
  }
}

module Icon = {
  let desktop =
    <svg width="32" height="32">
      <g transform="translate(5 8)" fill="none" fillRule="evenodd">
        <rect stroke="currentColor" x="2" width="18" height="13" rx="1" />
        <rect fill="currentColor" y="13" width="22" height="2" rx="1" />
      </g>
    </svg>

  let mobile =
    <svg width="32" height="32">
      <g transform="translate(11 7)" fill="none" fillRule="evenodd">
        <rect stroke="currentColor" width="10" height="18" rx="2" />
        <path d="M2 0h6v1a1 1 0 01-1 1H3a1 1 0 01-1-1V0z" fill="currentColor" />
      </g>
    </svg>

  let sidebar =
    <svg width="32" height="32">
      <g
        stroke="currentColor"
        strokeWidth="1.5"
        fill="none"
        fillRule="evenodd"
        strokeLinecap="round"
        strokeLinejoin="round">
        <path d="M25.438 17H12.526M19 10.287L12.287 17 19 23.713M8.699 7.513v17.2" />
      </g>
    </svg>

  let close =
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

  let categoryCollapsed =
    <svg
      width="20"
      height="17"
      viewBox="0 0 20 17"
      fill=Color.darkGray
      xmlns="http://www.w3.org/2000/svg">
      <rect x="2" y="1" width="16" height="2" />
      <rect x="2" y="7" width="16" height="2" />
      <rect x="2" y="13" width="16" height="2" />
    </svg>

  let categoryExpanded =
    <svg
      width="26"
      height="17"
      viewBox="0 0 26 17"
      fill=Color.darkGray
      xmlns="http://www.w3.org/2000/svg">
      <rect x="6" y="1" width="16" height="2" />
      <rect x="2" y="1" width="2" height="2" />
      <rect x="10" y="7" width="12" height="2" />
      <rect x="6" y="7" width="2" height="2" />
      <rect x="10" y="13" width="12" height="2" />
      <rect x="6" y="13" width="2" height="2" />
    </svg>
}



module Collapsible = {
  module Styles = {
    let clickableArea = ReactDOM.Style.make(
      ~display="flex",
      ~cursor="pointer",
      ~gridGap="2px",
      ~alignItems="center",
      (),
    )
  }

  let triangleIcon = isOpen =>
    <svg
      width="10"
      height="6"
      style={ReactDOM.Style.make(
        ~transition="200ms ease-out transform",
        ~transform=isOpen ? "" : "rotate(-90deg)",
        (),
      )}>
      <polygon points="0,0  10,0  5,6" fill=Color.darkGray />
    </svg>

  @react.component
  let make = (~title: React.element, ~isDefaultOpen: bool=false, ~isForceOpen=false, ~children) => {
    let (isOpen, setIsOpen) = React.useState(() => isDefaultOpen)

    React.useEffect1(() => {
      setIsOpen(_ => isDefaultOpen)
      None
    }, [isDefaultOpen])

    <div>
      <div style=Styles.clickableArea onClick={_event => setIsOpen(isOpen => !isOpen)}>
        {triangleIcon(isOpen)} title
      </div>
      {isForceOpen || isOpen ? children : React.null}
    </div>
  }
}
