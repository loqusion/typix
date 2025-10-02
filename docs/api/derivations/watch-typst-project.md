# watchTypstProject

Returns a derivation for a script that watches an input file and recompiles on
changes.

## Parameters

**Note:** All parameters for
[`writeShellApplication`][nixpkgs-writeshellapplication] are also supported
(besides `text`).

### `emojiFont` <sup><em>optional</em></sup> { #emojifont }

{{#include common/emoji-font.md}}

### `fontPaths` <sup><em>optional</em></sup> { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:watchtypstproject_example}}

### `forceVirtualPaths` <sup><em>optional</em></sup> { #forcevirtualpaths }

<!-- markdownlint-disable link-fragments -->

If there are any conflicts between [`virtualPaths`](#virtualpaths) and files in your
project directory, they will not be overwritten unless `forceVirtualPaths` is
`true`.

Default is `false`.

<!-- markdownlint-restore -->

### `scriptName` <sup><em>optional</em></sup> { #scriptname }

{{#include common/script-name.md}}

Default is `typst-watch`.

### `typstOpts` <sup><em>optional</em></sup> { #typstopts }

{{#include common/typst-opts.md:head}}

<!-- markdownlint-disable link-fragments -->

These are in addition to any options you manually pass in
[`typstWatchCommand`](#typstwatchcommand).

<!-- markdownlint-restore -->

{{#include common/typst-opts.md:tail}}

#### Example { #typstopts-example }

{{#include common/typst-opts-example.md:watchtypstproject}}
{{#include common/typst-opts-example.md:typstwatch}}

### `typstOutput` <sup><em>optional</em></sup> { #typstoutput }

{{#include common/typst-project-output.md:head}}
{{#include common/typst-project-output.md:watchtypstproject}}

### `typstSource` <sup><em>optional</em></sup> { #typstsource }

{{#include common/typst-project-source.md}}

Default is `main.typ`.

### `typstWatchCommand` <sup><em>optional</em></sup> { #typstwatchcommand }

Base Typst command to run to watch the project. Other arguments will be appended
based on the other parameters you supply.

Default is `typst watch`.

### `virtualPaths` <sup><em>optional</em></sup> { #virtualpaths }

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
