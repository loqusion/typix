# mkTypstDerivation

A generic derivation for running Typst commands.

## Parameters

All parameters for `stdenv.mkDerivation` are also available; see
[`stdenv` reference](https://nixos.org/manual/nixpkgs/stable/#chap-stdenv) (_not
recommended_).

### `buildPhaseTypstCommand`

### `src`

### `fontPaths` (optional)

A list of strings specifying paths to font files that will be made available to
your Typst project.

Used for setting `TYPST_FONT_PATHS` (see
[`text`](https://typst.app/docs/reference/text/text/)).

### `installPhaseCommand` (optional)

## Source

- [`mkTypstDerivation`](https://github.com/loqusion/typst.nix/blob/main/lib/mkTypstDerivation.nix)
