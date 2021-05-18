type numberConfig<'a> = {
  min: 'a,
  max: 'a,
  initial: 'a,
  step: 'a,
}

type stringConfig = string

type boolConfig = bool

type demo = {add: (string, Configs.demoUnitProps => React.element) => unit}

let demo: (Belt.MutableMap.String.key, demo => unit) => unit

let start: unit => unit
