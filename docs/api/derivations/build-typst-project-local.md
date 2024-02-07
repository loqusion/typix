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

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:buildtypstprojectlocal_example}}

### `installPhaseCommand` (optional) { #installphasecommand }

{{#include common/install-phase-command.md}}

### `localPaths` (optional) { #localpaths }

{{#include common/local-paths.md}}

#### Example { #localpaths-example }

{{#include common/local-paths-example.md:head}}
{{#include common/local-paths-example.md:buildtypstprojectlocal_example}}
{{#include common/local-paths-example.md:tail}}

### `scriptName` (optional) { #scriptname }

{{#include common/script-name.md}}

Default is `typst-build`.

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

### `typstOutput` (optional) { #typstoutput }

{{#include common/typst-project-output.md:head}}
{{#include common/typst-project-output.md:buildtypstprojectlocal}}

### `typstSource` (optional) { #typstsource }

{{#include common/typst-project-source.md}}

Default is `main.typ`.

## Source

- [`buildTypstProjectLocal`](https://github.com/loqusion/typix/blob/main/lib/buildTypstProjectLocal.nix)
