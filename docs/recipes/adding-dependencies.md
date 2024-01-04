# Adding Dependencies

You can add dependencies to your project using Typst.nix so that compilation
does not depend on the state of the local system: instead, any dependencies are
automatically fetched and made available in a sandboxed environment.

Examples of dependencies you might want to add:

- [Font files][typst-text--font] —
  [`fontPaths`](../api/derivations/mk-typst-derivation.md#fontpaths)
- [Image files][typst-image] —
  [`localPaths`](../api/derivations/mk-typst-derivation.md#localpaths)
- [Data files][typst-data] (e.g. [JSON][typst-data-json],
  [TOML][typst-data-toml], [XML][typst-data-xml]) —
  [`localPaths`](../api/derivations/mk-typst-derivation.md#localpaths)

## Fonts

Any fonts which are supported by Typst can also be used in projects with
Typst.nix. The only requirement is to add them to the `fontPaths` attr of any
[derivation builder](../api/derivations.md) you use.

### [nixpkgs][nixpkgs]

Many popular fonts have been uploaded as packages to [nixpkgs][nixpkgs], so it's
good to try that before anything else.

To determine the path(s) to the files you wish to include, first run the
following command (which creates a symbolic link named `result` in the current
directory):

```bash
nix-build '<nixpkgs>' --attr PACKAGE_NAME
```

Then explore the `result` with whichever commands you like — for instance, using
[`unix-tree`][unix-tree]:

```bash
tree ./result
```

```text
result
└── share
    └── fonts
        └── truetype
            ├── Roboto-BlackItalic.ttf
            ├── Roboto-Black.ttf
            ├── Roboto-BoldItalic.ttf
            ├── Roboto-Bold.ttf
            ├── RobotoCondensed-BoldItalic.ttf
            ├── RobotoCondensed-Bold.ttf
            ├── RobotoCondensed-Italic.ttf
            ├── RobotoCondensed-LightItalic.ttf
            ├── RobotoCondensed-Light.ttf
            ├── RobotoCondensed-MediumItalic.ttf
            ├── RobotoCondensed-Medium.ttf
            ├── RobotoCondensed-Regular.ttf
            ├── Roboto-Italic.ttf
            ├── Roboto-LightItalic.ttf
            ├── Roboto-Light.ttf
            ├── Roboto-MediumItalic.ttf
            ├── Roboto-Medium.ttf
            ├── Roboto-Regular.ttf
            ├── Roboto-ThinItalic.ttf
            └── Roboto-Thin.ttf

4 directories, 20 files
```

Here, we can see that the relative path should be `share/fonts/truetype`, so in
`flake.nix` we use that information like so:

{{#include ../api/derivations/common/font-paths-example.md:mktypstderivation_example}}

[nixpkgs]: https://search.nixos.org/packages
[typst-data-json]: https://typst.app/docs/reference/data-loading/json/
[typst-data-toml]: https://typst.app/docs/reference/data-loading/toml/
[typst-data-xml]: https://typst.app/docs/reference/data-loading/xml/
[typst-data]: https://typst.app/docs/reference/data-loading/
[typst-image]: https://typst.app/docs/reference/visualize/image/
[typst-text--font]: https://typst.app/docs/reference/text/text/#parameters-font
[unix-tree]: https://gitlab.com/OldManProgrammer/unix-tree
