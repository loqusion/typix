# buildTypstProjectLocal

Returns a derivation for compiling a Typst project and copying the output to the
current directory.

This is essentially a script which wraps
[`buildTypstProject`](build-typst-project.md).

<div class="warning">

Using this derivation requires
[`allow-import-from-derivation`](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-allow-import-from-derivation)
to be `true` (which is the default at the time of writing).

More info: <https://nixos.org/manual/nix/stable/language/import-from-derivation>

</div>

<div class="warning">

Invoking the script produced by this derivation directly is currently
unsupported. Instead, use `nix run`.

See [this issue](https://github.com/loqusion/typix/issues/2) for more
information.

</div>

## Parameters

All parameters accepted by
[`buildTypstProject`](build-typst-project.md#parameters) are also accepted by
`buildTypstProjectLocal`. They are repeated below for convenience.

### `src`

{{#include common/src.md}}

### `emojiFont` <sup><em>optional</em></sup> { #emojifont }

{{#include common/emoji-font.md}}

### `fontPaths` <sup><em>optional</em></sup> { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildtypstprojectlocal_example}}

### `installPhaseCommand` <sup><em>optional</em></sup> { #installphasecommand }

{{#include common/install-phase-command.md}}

### `scriptName` <sup><em>optional</em></sup> { #scriptname }

{{#include common/script-name.md}}

Default is `typst-build`.

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

{{#include common/typst-opts-example.md:head}}
{{#include common/typst-opts-example.md:typstcompile}}

### `typstOutput` <sup><em>optional</em></sup> { #typstoutput }

{{#include common/typst-project-output.md:head}}
{{#include common/typst-project-output.md:buildtypstprojectlocal}}

### `typstSource` <sup><em>optional</em></sup> { #typstsource }

{{#include common/typst-project-source.md}}

Default is `main.typ`.

### `unstableTypstPackages` <sup><em>optional</em></sup> { #typstpackages }

{{#include common/typst-packages.md:body}}

#### Example { #typstpackages-example }

{{#include common/typst-packages.md:example_buildtypstprojectlocal}}
{{#include common/typst-packages.md:example_typst}}

### `virtualPaths` <sup><em>optional</em></sup> { #virtualpaths }

{{#include common/virtual-paths.md}}

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:buildtypstprojectlocal_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`buildTypstProjectLocal`](https://github.com/loqusion/typix/blob/main/lib/buildTypstProjectLocal.nix)
