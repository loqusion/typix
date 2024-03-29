# Adding dependencies

You can add dependencies to your [flake
inputs][nix-ref-flake-inputs][^zero-to-nix-flakes] so that Typst compilation
does not depend on the transient state of the local system: instead, any
dependencies are automatically fetched and made available in a sandboxed
environment.

Examples of dependencies you might want to add:

- [Font files][typst-ref-text--font] —
  [`fontPaths`](../api/derivations/mk-typst-derivation.md#fontpaths)
- [Image files][typst-ref-image] —
  [`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths)
- [Data files][typst-ref-data-loading] (e.g. [JSON][typst-ref-data-json],
  [TOML][typst-ref-data-toml], [XML][typst-ref-data-xml]) —
  [`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths)

For a more complete description of how to specify flake inputs, see the Nix
Reference Manual [section on flakerefs][nix-ref-flake-references].

[^zero-to-nix-flakes]: See also: <https://zero-to-nix.com/concepts/flakes>

## nixpkgs

Many popular fonts are available as packages to [nixpkgs][nixpkgs], so if you're
wanting to add a font it's good to try that before anything else.

To determine the path(s) to the files you wish to include, first run the
following command (which creates a symbolic link named `result` in the current
directory):

```bash
nix-build '<nixpkgs>' --out-link result --attr PACKAGE_NAME
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
```

Here, we can see that the relative path should be `share/fonts/truetype`, so in
`flake.nix` we use that information like so:

{{#include ../api/derivations/common/font-paths-example.md:mktypstderivation_example}}

## GitHub

[GitHub](https://github.com) hosts a great deal of fonts and icon libraries, and
Nix makes it easy to add GitHub repositories as flake inputs with [URL-like
syntax][nix-ref-flake-url].

Here's an example of specifying a GitHub URL as a flake input and adding it to
[`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths), specifying
that we want the `svgs/regular` directory to be accessible from `icons`:

{{#include ../api/derivations/common/virtual-paths-example.md:mktypstderivation_example}}

With this, we can use it in Typst as if it were any other local path:

{{#include ../api/derivations/common/virtual-paths-example.md:typst_example}}

## Using local files

If all else fails, you can always manually download what you need and move it to
your Typst project directory.

Here's what you need to know:

- The Typst compiler invoked by
  [`buildTypstProject`](../api/derivations/build-typst-project.md),
  [`buildTypstProjectLocal`](../api/derivations/build-typst-project-local.md),
  etc. won't see the files you've added unless they're present in one of the
  source tree parameters — in practice, these are
  [`src`](../api/derivations/mk-typst-derivation.md#src),
  [`fontPaths`](../api/derivations/mk-typst-derivation.md#fontpaths), and
  [`virtualPaths`](../api/derivations/mk-typst-derivation.md#virtualpaths). (This
  doesn't apply to
  [`watchTypstProject`](../api/derivations/watch-typst-project.md).)
- Paths to font files must still be passed in
  [`fontPaths`](../api/derivations/mk-typst-derivation.md#fontpaths) or
  otherwise made known to the Typst compiler (e.g. via
  [`--font-path`][typst-man-compile--font-path]).

See ["Specifying sources"](./specifying-sources.md#expanding-a-source-tree) for
information on how to expand a source tree to include the files you need.

[nix-ref-flake-inputs]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake#flake-inputs
[nix-ref-flake-references]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake#flake-references
[nix-ref-flake-url]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake#url-like-syntax
[nixpkgs]: https://search.nixos.org/packages
[typst-man-compile--font-path]: https://man.archlinux.org/man/typst-compile.1.en#font
[typst-ref-data-json]: https://typst.app/docs/reference/data-loading/json/
[typst-ref-data-loading]: https://typst.app/docs/reference/data-loading/
[typst-ref-data-toml]: https://typst.app/docs/reference/data-loading/toml/
[typst-ref-data-xml]: https://typst.app/docs/reference/data-loading/xml/
[typst-ref-image]: https://typst.app/docs/reference/visualize/image/
[typst-ref-text--font]: https://typst.app/docs/reference/text/text/#parameters-font
[unix-tree]: https://gitlab.com/OldManProgrammer/unix-tree
