# SwiftGir

SwiftGir is a library, with accompanying CLI-tool to convert GObject repository
files to their Swift source representation.

## Prior Art

Before starting to develop this library, I took a look at the bigger ecosystem
surrounding Swift and GObject.

There two implementations, which generate Swift from GIR files.
The first option, which can be seen as a mature, is
[gir2swift by Rene Hexel](https://github.com/rhx/gir2swift) and the second
option is [GtkCodeGen by stackotter](https://github.com/stackotter/swift-cross-ui/tree/52ef10a131b6c4c717db1532536d816f4c2c21df/Sources/GtkCodeGen) developed as part
of their [swift-cross-ui](https://github.com/stackotter/swift-cross-ui) efforts.

One outstanding implementation, I want to highlight and plan on referencing a lot,
is [gotk4 by diamondburned](https://github.com/diamondburned/gotk4), which did
an exceptional job at providing a Go-esque abstraction over the GObject libraries.

## Getting Started

To build the CLI from source, run the following command.

```sh
$ swift build -c release
```

The produced binary is placed at `.build/release/swift-gir`.
