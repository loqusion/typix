# buildTypstProject

A derivation for compiling a Typst project.

If you want to build to the project directory, use
[`buildLocalTypstProject`](build-local-typst-project.md) instead.

## Parameters

All parameters accepted by
[`mkTypstDerivation`](mk-typst-derivation.md#parameters) are also accepted by
`buildTypstProject`. They are repeated below for convenience.

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildtypstproject_example}}

### `installPhaseCommand` (optional) { #installphasecommand }

{{#include common/install-phase-command.md}}

### `localPaths` (optional) { #localpaths }

{{#include common/local-paths.md}}

#### Example { #localpaths-example }

{{#include common/local-paths-example.md:head}}
{{#include common/local-paths-example.md:buildtypstproject_example}}
{{#include common/local-paths-example.md:tail}}

### `typstCompileCommand` (optional) { #typstcompilecommand }

{{#include common/typst-compile-command.md}}

### `typstOpts` (optional) { #typstopts }

{{#include common/typst-opts.md:head}}

<!-- markdownlint-disable link-fragments -->

These are in addition to any options you manually pass in
[`typstCompileCommand`](#typstcompilecommand).

<!-- markdownlint-restore -->

{{#include common/typst-opts.md:tail}}

#### Example { #typstopts-example }

{{#include common/typst-opts-example.md:head}}
{{#include common/typst-opts-example.md:typstcompile}}

### `typstSource` (optional) { #typstsource }

{{#include common/typst-project-source.md}}

## Source

- [`buildTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildTypstProject.nix)
