# Reshowcase

⚠️ this is a fork of [original tool](https://github.com/bloodyowl/reshowcase) with `rescript-react` migration reverted, `reason-react` is used instead ⚠️

> A tool to create demos for your ReScript React components

![Screenshot](./example/example-2021.png)

```rescript
open Reshowcase.Entry

// Create a demo
demo("Title", ({add}) => {
  // Add an example
  add("normal", ({string}) =>
    // Register "handles" from your JSX directly
    <h1> {string("text", "hello")->React.string} </h1>
  )
  add("font-size", ({string, int}) =>
    <h1
      style={ReactDOM.Style.make(
        ~fontSize={
          // Handles can be strings, ints, floats and booleans
          let size = int("font size", {min: 0, max: 100, initial: 30, step: 1})
          `${size->Belt.Int.toString}px`
        },
        (),
      )}>
      {string("text", "hello")->React.string}
    </h1>
  )
})

demo("Button", ({add}) =>
  add("normal", ({string, bool}) =>
    <button disabled={bool("disabled", false)}>
      {string("text", "hello")->React.string}
    </button>
  )
)

start()
```

## Install

```console
yarn add --dev reshowcase
```

Then add to your `"reshowcase"` to `bs-dependencies` in your `bsconfig.json`.

> If you're still using JSX 2, install `reshowcase@1.4.0`.

## Usage

### To start / develop:

```console
$ reshowcase start --entry=path/to/Demo.bs.js
```

### To build bundle:

```console
$ reshowcase build --entry=path/to/Demo.bs.js --output=path/to/bundle
```

If you need custom webpack options, create the `.reshowcase/config.js` and export the webpack config, plugins and modules will be merged.

If you need a custom template, pass `--template=./path/to/template.html`.
