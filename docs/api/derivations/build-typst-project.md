# buildTypstProject

A derivation for compiling a Typst project.

If you want to build to the project directory, use
[`buildLocalTypstProject`](build-local-typst-project.md) instead.

## Parameters

All parameters accepted by
[`mkTypstDerivation`](mk-typst-derivation.md#parameters) are also accepted by
`buildTypstProject` (except for
[`buildPhaseTypstCommand`](mk-typst-derivation.md#buildphasetypstcommand), which
is constructed from the below parameters).

### `typstCompileCommand` (optional) { #typstcompilecommand }

Base Typst command to run to compile the project. `buildTypstProject` will
append other arguments based on the other parameters you supply. Default is
`typst compile`.

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

### `typstProjectSource` (optional) { #typstprojectsource }

{{#include common/typst-project-source.md}}

## Source

- [`buildTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/buildTypstProject.nix)
