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

The command (or commands) to run during
[`buildPhase`](https://nixos.org/manual/nixpkgs/stable/#build-phase).

> See also: [Typst CLI Usage](https://github.com/typst/typst#usage)

### `src`

### `fontPaths` (optional) { #fontpaths }

A list of strings specifying paths to font files that will be made available to
your Typst project. With this, you can compile Typst projects even when the
fonts it uses are not available on your system.

Used for setting `TYPST_FONT_PATHS` (see
[`text`](https://typst.app/docs/reference/text/text/)).

#### Example

```nix
{
  outputs = { nixpkgs }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = typst-nix.lib.${system}.mkTypstDerivation {
      fontPaths = [
        "${pkgs.roboto}/share/fonts/truetype"
      ];
    };
  }
}
```

### `installPhaseCommand` (optional) { #installphasecommand }

The command (or commands) to run during
[`installPhase`](https://nixos.org/manual/nixpkgs/stable/#ssec-install-phase).

### `localPaths` (optional) { #localpaths }

List of paths that will be made locally available to your Typst project. Useful
for projects which rely on remote resources, such as
[images](https://typst.app/docs/reference/visualize/image/) or
[data](https://typst.app/docs/reference/data-loading/).

Each element of the list is an attribute set with the following keys:

- `src`: path to source directory
- `dest` (optional): path where files will be made available (defaults to `.`)

Instead of an attrset, you may use a path which will be interpreted the same as
if you had specified an attrset with just `src`.

#### Example

You can specify dependencies in your flake input, and then use them in your
project with something like:

```nix
{
  inputs = {
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };
  };

  outputs = { typst-nix, font-awesome }: let
    system = "x86_64-linux";
  in {
    packages.${system}.default = typst-nix.lib.${system}.mkTypstDerivation {
      localPaths = [
        {
          dest = "icons";
          src = "${font-awesome}/svgs/regular";
        }
      ];
    };
  };
}
```

Then, reference the files in Typst:

```typst
#image("icons/heart.svg")
```

## Source

- [`mkTypstDerivation`](https://github.com/loqusion/typst.nix/blob/main/lib/mkTypstDerivation.nix)
