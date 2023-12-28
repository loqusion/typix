# mkTypstDerivation

A generic derivation for running Typst commands.

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

List of sources specifying paths to font files that will be made available to
your Typst project. With this, you can compile Typst projects even when the
fonts it uses are not available on your system.

Used for setting `TYPST_FONT_PATHS` (see [`text`][typst-text]).

#### Example { #fontpaths-example }

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

Command (or commands) to run during
[`installPhase`][nix-derivation-install-phase].

### `localPaths` (optional) { #localpaths }

List of sources that will be made locally available to your Typst project.
Useful for projects which rely on remote resources, such as
[images][typst-image] or [data][typst-data].

Each element of the list is an attribute set with the following keys:

- `src`: path to source directory
- `dest` (optional): path where files will be made available (defaults to `.`)

Instead of an attrset, you may use a path which will be interpreted the same as
if you had specified an attrset with just `src`.

#### Example { #localpaths-example }

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

## Footnotes

[^stdenv]: [`stdenv`](https://nixos.org/manual/nixpkgs/stable/#chap-stdenv)

[nix-derivation-build-phase]: https://nixos.org/manual/nixpkgs/stable/#build-phase
[nix-derivation-install-phase]: https://nixos.org/manual/nixpkgs/stable/#ssec-install-phase
[typst-cli-usage]: https://github.com/typst/typst#usage
[typst-data]: https://typst.app/docs/reference/data-loading/
[typst-image]: https://typst.app/docs/reference/visualize/image/
[typst-text]: https://typst.app/docs/reference/text/text/
