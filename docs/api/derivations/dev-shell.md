# devShell

Sets up a shell environment that activates with [`nix develop`][nix-ref-develop]
or [`direnv`][direnv].

> **TODO**

## Parameters

**Note:** All parameters for [`mkShell`][nixpkgs-mkshell] are also
supported.

### extraShellHook (optional) { #extrashellhook }

Bash statements added to the [`shellHook`][nixpkgs-mkshell-attributes]
attribute.

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:devshell_example}}

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
{{#include common/local-paths-example.md:devshell_example}}
{{#include common/local-paths-example.md:tail}}

## Source

- [`devShell`](https://github.com/loqusion/typst.nix/blob/main/lib/devShell.nix)

[direnv]: https://direnv.net/
[nix-ref-develop]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop
[nixpkgs-mkshell-attributes]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell-attributes
[nixpkgs-mkshell]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell
