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

### `emojiFont` <sup><em>optional</em></sup> { #emojifont }

{{#include common/emoji-font.md}}

### `fontPaths` <sup><em>optional</em></sup> { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildtypstproject_example}}

### `installPhaseCommand` <sup><em>optional</em></sup> { #installphasecommand }

{{#include common/install-phase-command.md}}

### `typstCompileCommand` <sup><em>optional</em></sup> { #typstcompilecommand }

{{#include common/typst-compile-command.md}}

Default is `typst compile`.

### `typstOpts` <sup><em>optional</em></sup> { #typstopts }

{{#include common/typst-opts.md:head}}

<!-- markdownlint-disable link-fragments -->

These are in addition to any options you manually pass in
[`typstCompileCommand`](#typstcompilecommand).

<!-- markdownlint-restore -->

{{#include common/typst-opts.md:tail}}

#### Example { #typstopts-example }

{{#include common/typst-opts-example.md:buildtypstproject}}
{{#include common/typst-opts-example.md:typstcompile}}

### `typstSource` <sup><em>optional</em></sup> { #typstsource }

{{#include common/typst-project-source.md}}

Default is `main.typ`.

### `unstable_typstPackages` <sup><em>optional</em></sup> { #typstpackages }

{{#include common/typst-packages.md:body}}

#### Example { #typstpackages-example }

{{#include common/typst-packages.md:example_buildtypstproject}}
{{#include common/typst-packages.md:example_typst}}

### `virtualPaths` <sup><em>optional</em></sup> { #virtualpaths }

{{#include common/virtual-paths.md}}

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:buildtypstproject_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`buildTypstProject`](https://github.com/loqusion/typix/blob/main/lib/buildTypstProject.nix)
