# watchTypstProject

Returns a derivation for a script that watches an input file and recompiles on
changes.

This script is exposed to the user's environment, so expect the output to not be
reproducible.

## Parameters

**Note:** All parameters for [`writeShellApplication`][write-shell-application]
are also supported (besides `text`).

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:watchtypstproject_example}}

### `forceLocalPaths` (optional) { #forcelocalpaths }

<!-- markdownlint-disable link-fragments -->

If there are any conflicts between [`localPaths`](#localpaths) and files in your
project directory, they will not be overwritten unless `forceLocalPaths` is
`true`.

Default is `false`.

<!-- markdownlint-restore -->

### `localPaths` (optional) { #localpaths }

{{#include common/local-paths.md}}

<!-- markdownlint-disable link-fragments -->

**NOTE:** Any paths specified here will not overwrite files in your project
directory, unless you set [`forceLocalPaths`](#forcelocalpaths) to `true`.

<!-- markdownlint-restore -->

#### Example { #localpaths-example }

{{#include common/local-paths-example.md:head}}
{{#include common/local-paths-example.md:watchtypstproject_example}}
{{#include common/local-paths-example.md:tail}}

### `scriptName` (optional) { #scriptname }

{{#include common/script-name.md}}

Default is `typst-watch`.

### `typstOpts` (optional) { #typstopts }

{{#include common/typst-opts.md:head}}

<!-- markdownlint-disable link-fragments -->

These are in addition to any options you manually pass in
[`typstWatchCommand`](#typstwatchcommand).

<!-- markdownlint-restore -->

{{#include common/typst-opts.md:tail}}

#### Example { #typstopts-example }

{{#include common/typst-opts-example.md:head}}
{{#include common/typst-opts-example.md:typstwatch}}

### `typstOutput` (optional) { #typstoutput }

{{#include common/typst-project-output.md:head}}
{{#include common/typst-project-output.md:watchtypstproject}}

### `typstSource` (optional) { #typstsource }

{{#include common/typst-project-source.md}}

Default is `main.typ`.

### `typstWatchCommand` (optional) { #typstwatchcommand }

Base Typst command to run to watch the project. Other arguments will be appended
based on the other parameters you supply.

Default is `typst watch`.

## Source

- [`watchTypstProject`](https://github.com/loqusion/typst.nix/blob/main/lib/watchTypstProject.nix)

[write-shell-application]: https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
