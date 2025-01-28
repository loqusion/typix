# devShell

Sets up a shell environment that activates with [`nix develop`][nix-ref-develop]
or [`direnv`][direnv].

## Parameters

**Note:** All parameters for [`mkShell`][nixpkgs-mkshell] are also
supported.

### `emojiFont` (optional) { #emojifont }

{{#include common/emoji-font.md}}

### extraShellHook (optional) { #extrashellhook }

Bash statements added to the [`shellHook`][nixpkgs-mkshell-attributes]
attribute.

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:devshell_example}}

### `forceVirtualPaths` (optional) { #forcevirtualpaths }

<!-- markdownlint-disable link-fragments -->

If there are any conflicts between [`virtualPaths`](#virtualpaths) and files in your
project directory, they will not be overwritten unless `forceVirtualPaths` is
`true`.

Default is `false`.

<!-- markdownlint-restore -->

### `virtualPaths` (optional) { #virtualpaths }

{{#include common/virtual-paths.md}}

<!-- markdownlint-disable link-fragments -->

**NOTE:** Any paths specified here will not overwrite files in your project
directory, unless you set [`forceVirtualPaths`](#forcevirtualpaths) to `true`.

<!-- markdownlint-restore -->

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:devshell_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`devShell`](https://github.com/loqusion/typix/blob/main/lib/devShell.nix)

[direnv]: https://direnv.net/
[nix-ref-develop]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop
[nixpkgs-mkshell-attributes]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell-attributes
[nixpkgs-mkshell]: https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell
