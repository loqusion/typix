# Specifying sources

A number of derivations in Typix accept source trees as parameters, such as
[`src`](../api/derivations/mk-typst-derivation.md#src),
[`fontPaths`](../api/derivations/mk-typst-derivation.md#fontpaths), and
[`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths). Specifying
these is usually as simple as
[`cleanTypstSource`](../api/utilities/clean-typst-source.md) in the case of
`src` and string interpolation (via `${...}`) in the case of `fontPaths` and
`virtualPaths`, but there are situations where more is required or desirable:

- `cleanTypstSource` omits local files which are required by your Typst project
- An input you're sourcing contains a large number of files which would be
  expensive to copy to the Nix store, resulting in longer build times and higher
  disk usage

## Expanding a source tree

> TL;DR: you can use [`lib.sources.cleanSource`][nixpkgs-sources-cleansource],
> but the problem with this approach is that every change to a file tracked by
> git will invalidate the cache and trigger a rebuild.

To include more _local files_[^fileset-note] in a source tree, you can use a
combination of different functions in [`lib.fileset`][nixpkgs-fileset]
such as [`lib.fileset.unions`][nixpkgs-fileset-unions],
[`lib.fileset.fromSource`][nixpkgs-fileset-fromsource], and
[`lib.fileset.toSource`][nixpkgs-fileset-tosource], like so:

```nix
{
  outputs = { nixpkgs, typix }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;
    typixLib = typix.lib.${system};
    myTypstSource = typixLib.cleanTypstSource ./.;
  in {
    packages.${system}.default = typixLib.mkTypstDerivation {
      src = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          (lib.fileset.fromSource myTypstSource)
          ./path.svg
          ./other/path.svg
          ./another
        ];
      };
    };
  };
}
```

This will create a source tree that looks something like:

```text
/nix/store/...
├── another
│  ├── path1.svg
│  ├── path2.svg
│  └── path3.svg
├── path.svg
├── other
│  └── path.svg
└── ...
```

<!-- prettier-ignore-start -->
[^fileset-note]: `lib.fileset` functions can only be used with local files, not
e.g. flake inputs, which is what
[`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths) is for.
<!-- prettier-ignore-end -->

## Source filtering

You can do source filtering primarily using
[`builtins.filterSource`][nix-ref-builtins-filtersource] and functions in
[`lib.sources`][nixpkgs-sources] such as
[`lib.sources.cleanSourceWith`][nixpkgs-sources-cleansourcewith].

A more detailed explanation can be found in the Nix discussion: ["Filtering
Source Trees with Nix and Nixpkgs"][nix-discussion-source-filtering].

Here's an example which picks specific files by name:

```nix
{
  outputs = { nixpkgs, typix, font-awesome }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    fontAwesomeSubset = let
      icons = [
        "gem.svg"
        "heart.svg"
        "lightbulb.svg"
      ];
    in lib.sources.cleanSourceWith {
      src = "${font-awesome}/svgs/regular";
      filter = path: type:
        builtins.any (icon: builtins.baseNameOf path == icon) icons;
    };
  in {
    packages.${system}.default = typix.lib.${system}.mkTypstDerivation {
      virtualPaths = [
        fontAwesomeSubset
      ];
    };
  };
}
```

[nix-discussion-source-filtering]: https://discourse.nixos.org/t/filtering-source-trees-with-nix-and-nixpkgs/19148
[nix-ref-builtins-filtersource]: https://nixos.org/manual/nix/stable/language/builtins.html#builtins-filterSource
[nixpkgs-fileset-fromsource]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fileset.fromSource
[nixpkgs-fileset-tosource]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fileset.toSource
[nixpkgs-fileset-unions]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.fileset.unions
[nixpkgs-fileset]: https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-fileset
[nixpkgs-sources-cleansource]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.sources.cleanSource
[nixpkgs-sources-cleansourcewith]: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.sources.cleanSourceWith
[nixpkgs-sources]: https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-sources
