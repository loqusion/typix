# mkTypstDerivation

A generic derivation for running Typst commands.

## Parameters

All parameters for `stdenv.mkDerivation` are also available; see
[`stdenv` reference](https://nixos.org/manual/nixpkgs/stable/#chap-stdenv) (_not
recommended_).

<!-- The essence of good documentation is to split knowledge into small and
easily digestible chunks, which the above linked documentation does not succeed
in doing. The "not recommended" comment should be removed when such
documentation exists for `mkDerivation` in an official capacity (of course, said
documentation should also be linked).

Also see https://github.com/NixOS/nixpkgs/issues/18678. -->

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
