# watchTypstProject

Returns a derivation for a script that watches an input file and recompiles on
changes.

This script is exposed to the user's environment, so expect the output to not be
reproducible.

## Parameters

**Note:** All parameters for
[`writeShellApplication`][nixpkgs-writeshellapplication] are also supported
(besides `text`).

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:watchtypstproject_example}}

### `forceVirtualPaths` (optional) { #forcevirtualpaths }

<!-- markdownlint-disable link-fragments -->

If there are any conflicts between [`virtualPaths`](#virtualpaths) and files in your
project directory, they will not be overwritten unless `forceVirtualPaths` is
`true`.

Default is `false`.

<!-- markdownlint-restore -->

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

### `virtualPaths` (optional) { #virtualpaths }

{{#include common/virtual-paths.md}}

<!-- markdownlint-disable link-fragments -->

**NOTE:** Any paths specified here will not overwrite files in your project
directory, unless you set [`forceVirtualPaths`](#forcevirtualpaths) to `true`.

<!-- markdownlint-restore -->

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:watchtypstproject_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`watchTypstProject`](https://github.com/loqusion/typix/blob/main/lib/watchTypstProject.nix)

[nixpkgs-writeshellapplication]: https://nixos.org/manual/nixpkgs/stable/#trivial-builder-writeShellApplication
