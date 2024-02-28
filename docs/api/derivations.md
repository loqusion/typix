# Derivations

As paraphrased from [the Nix Reference Manual][nix-ref-derivations]:

> A derivation is a specification for running an executable on precisely defined
> input files to repeatably produce output files at uniquely determined file
> system paths.

The derivation constructors defined in Typix extend this behavior by running
`typst compile`/`typst watch` in a context where all the dependencies of your
Typst project (fonts, images, etc.) will be made available to the Typst
compiler, regardless of if they're already present on the system it runs on.

- [`buildTypstProjectLocal`](derivations/build-typst-project-local.md) — Returns
  a derivation for compiling a Typst project and copying the output to the
  current directory.
- [`buildTypstProject`](derivations/build-typst-project.md) — Returns a
  derivation for compiling a Typst project.
- [`devShell`](derivations/dev-shell.md) — Sets up a shell environment that
  activates with [`nix develop`][nix-ref-develop] or [`direnv`][direnv].
- [`mkTypstDerivation`](derivations/mk-typst-derivation.md) — A generic
  derivation constructor for running Typst commands.
- [`watchTypstDerivation`](derivations/watch-typst-project.md) — Returns a
  derivation for a script that watches an input file and recompiles on changes.

[direnv]: https://direnv.net/
[nix-ref-derivations]: https://nixos.org/manual/nix/stable/language/derivations.html
[nix-ref-develop]: https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-develop
