type root
@module("react-dom/client")
external createRoot: Dom.element => root = "createRoot"

@send
external renderFromRoot: (root, React.element) => unit = "render"
