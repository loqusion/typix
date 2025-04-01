# mkTypstDerivation

A generic derivation constructor for running Typst commands.

## Parameters

**Note:** All parameters for `stdenv.mkDerivation`[^stdenv] are also available.

### `buildPhaseTypstCommand`

Command (or commands) to run during [`buildPhase`][nixpkgs-buildphase]. Any
output should typically be written to `$out`, e.g. `typst compile <source>
"$out"`.

See also: [Typst CLI Usage][typst-cli-usage]

### `src`

{{#include common/src.md}}

### `emojiFont` <sup><em>optional</em></sup> { #emojifont }

{{#include common/emoji-font.md}}

### `fontPaths` <sup><em>optional</em></sup> { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:mktypstderivation_example}}

### `installPhaseCommand` <sup><em>optional</em></sup> { #installphasecommand }

{{#include common/install-phase-command.md}}

### `unstable_typstPackages` <sup><em>optional</em></sup> { #typstpackages }

{{#include common/typst-packages.md:body}}

#### Example { #typstpackages-example }

{{#include common/typst-packages.md:example_mktypstderivation}}
{{#include common/typst-packages.md:example_typst}}

### `virtualPaths` <sup><em>optional</em></sup> { #virtualpaths }

{{#include common/virtual-paths.md}}

#### Example { #virtualpaths-example }

{{#include common/virtual-paths-example.md:head}}
{{#include common/virtual-paths-example.md:mktypstderivation_example}}
{{#include common/virtual-paths-example.md:tail}}

## Source

- [`mkTypstDerivation`](https://github.com/loqusion/typix/blob/main/lib/mkTypstDerivation.nix)

## Footnotes

[^stdenv]: [`stdenv`][nixpkgs-stdenv] (not for the faint of heart)

[nixpkgs-buildphase]: https://nixos.org/manual/nixpkgs/stable/#build-phase
[nixpkgs-stdenv]: https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
[typst-cli-usage]: https://github.com/typst/typst#usage
