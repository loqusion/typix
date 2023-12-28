# Specifying sources

A number of derivations in Typst.nix accept source trees as parameters, such as
[`src`](api/derivations/mk-typst-derivation.md#src),
[`fontPaths`](api/derivations/mk-typst-derivation.md#fontpaths), and
[`localPaths`](api/derivations/mk-typst-derivation.md#localpaths). Specifying
these is usually as simple as
[`cleanTypstSource`](api/utilities/clean-typst-source.md) in the case of `src`
and string interpolation (via `${...}`) in the case of `fontPaths` and
`localPaths`, but there are situations where more is required or desirable:

- `cleanTypstSource` omits local files which are required by your Typst project
- An input you're sourcing contains a large number of files which would be
  expensive to copy to the Nix store, resulting in longer build times and higher
  disk usage

<https://discourse.nixos.org/t/filtering-source-trees-with-nix-and-nixpkgs/19148>
