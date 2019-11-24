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
  };
  [@react.component]
  let make = (~children, _) =>
    <div style=Styles.container> {children->List.toArray->React.array} </div>;
};

module DemoUnit = {
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
  let make = (~demoUnit) => {
    let elements = demoUnit();
    let (el, sidebarControls) =
      switch (elements->List.reverse) {
      | [] => failwith("Missing element in demo unit")
      | [el, ...sidebarControls] => (el, sidebarControls)
      };
    <div style=Styles.container>
      <div style=Styles.contents> el </div>
      <div style=Styles.sidebar>
        <DemoUnitSidebar> sidebarControls </DemoUnitSidebar>
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
