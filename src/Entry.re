open Belt;

type demo = {
  add: (string, Configs.demoUnit => ReasonReact.reactElement) => unit,
};

let demos = MutableMap.String.make();

let demo = (demoName, func) => {
  let demoUnits = MutableMap.String.make();
  let demo = {
    add: (demoUnitName, demo: Configs.demoUnit => ReasonReact.reactElement) => {
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
