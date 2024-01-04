# mkTypstDerivation

A generic derivation builder for running Typst commands.

## Parameters

**Note:** All parameters for `stdenv.mkDerivation`[^stdenv] are also available.

### `buildPhaseTypstCommand`

Command (or commands) to run during [`buildPhase`][nix-derivation-build-phase].
Any output should typically be written to `$out`, e.g. `typsts compile <source>
"$out"`.

See also: [Typst CLI Usage][typst-cli-usage]

### `src`

> **TODO**

### `fontPaths` (optional) { #fontpaths }

{{#include common/font-paths.md}}

#### Example { #fontpaths-example }

{{#include common/font-paths-example.md:mktypstderivation_example}}

### `installPhaseCommand` (optional) { #installphasecommand }

{{#include common/install-phase-command.md}}

### `localPaths` (optional) { #localpaths }

{{#include common/local-paths.md}}

#### Example { #localpaths-example }

{{#include common/local-paths-example.md:head}}
{{#include common/local-paths-example.md:mktypstderivation_example}}
{{#include common/local-paths-example.md:tail}}

## Source

- [`mkTypstDerivation`](https://github.com/loqusion/typst.nix/blob/main/lib/mkTypstDerivation.nix)

## Footnotes

[^stdenv]: [`stdenv`][nix-ref-stdenv] (not for the faint of heart)

[nix-derivation-build-phase]: https://nixos.org/manual/nixpkgs/stable/#build-phase
[nix-ref-stdenv]: https://nixos.org/manual/nixpkgs/stable/#chap-stdenv
[typst-cli-usage]: https://github.com/typst/typst#usage
