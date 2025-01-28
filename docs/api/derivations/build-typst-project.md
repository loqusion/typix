# buildTypstProject

Returns a derivation for compiling a Typst project.

If you want to build to the project directory, use
[`buildTypstProjectLocal`](build-typst-project-local.md) instead.

## Parameters

All parameters accepted by
[`mkTypstDerivation`](mk-typst-derivation.md#parameters) are also accepted by
`buildTypstProject`. They are repeated below for convenience.

### `src`

{{#include common/src.md}}

### `emojiFont` (optional) { #emojifont }

{{#include common/emoji-font.md}}

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildtypstproject_example}}

### `installPhaseCommand` (optional) { #installphasecommand }

{{#include common/install-phase-command.md}}

### `typstCompileCommand` (optional) { #typstcompilecommand }

{{#include common/typst-compile-command.md}}

Default is `typst compile`.

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

Default is `main.typ`.

### `virtualPaths` (optional) { #virtualpaths }

{{#include common/virtual-paths.md}}

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:buildtypstproject_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`buildTypstProject`](https://github.com/loqusion/typix/blob/main/lib/buildTypstProject.nix)
